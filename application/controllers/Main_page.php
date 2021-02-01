<?php

use Model\Login_model;
use Model\Post_model;
use Model\User_model;
use Model\Boosterpack_model;
use Model\Comment_model;

/**
 * Created by PhpStorm.
 * User: mr.incognito
 * Date: 10.11.2018
 * Time: 21:36
 */
class Main_page extends MY_Controller
{

    public function __construct()
    {
        parent::__construct();

        if (is_prod())
        {
            die('In production it will be hard to debug! Run as development environment!');
        }
    }

    public function index()
    {
        $user = User_model::get_user();

        App::get_ci()->load->view('main_page', ['user' => User_model::preparation($user, 'default')]);
    }

    public function get_all_posts()
    {
        $posts =  Post_model::preparation(Post_model::get_all(), 'main_page');
        return $this->response_success(['posts' => $posts]);
    }

    public function get_post($post_id){ // or can be $this->input->post('news_id') , but better for GET REQUEST USE THIS

        $post_id = intval($post_id);

        if (empty($post_id)){
            return $this->response_error(CI_Core::RESPONSE_GENERIC_WRONG_PARAMS);
        }

        try
        {
            $post = new Post_model($post_id);
        } catch (EmeraldModelNoDataException $ex){
            return $this->response_error(CI_Core::RESPONSE_GENERIC_NO_DATA);
        }


        $posts =  Post_model::preparation($post, 'full_info');
        return $this->response_success(['post' => $posts]);
    }


    public function comment(){ // or can be App::get_ci()->input->post('news_id') , but better for GET REQUEST USE THIS ( tests )

        $post_id = App::get_ci()->input->post('post_id');
        $message = App::get_ci()->input->post('message');

        if (!User_model::is_logged()){
            return $this->response_error(CI_Core::RESPONSE_GENERIC_NEED_AUTH, ['error_text' => 'You are not authorized']);
        }

        $post_id = intval($post_id);

        if (empty($post_id) || empty($message)){
            return $this->response_error(CI_Core::RESPONSE_GENERIC_WRONG_PARAMS, ['error_text' => 'Post is not sent']);
        }

        try
        {
            $post = new Post_model($post_id);
        } catch (EmeraldModelNoDataException $ex){
            return $this->response_error(CI_Core::RESPONSE_GENERIC_NO_DATA, ['error_text' => 'Post is not found']);
        }

        // Todo: 2 nd task Comment
        $post->comment();
        $data = array(
            'assign_id' => $post_id,
            'text' => $message,
            'user_id' => User_model::get_session_id()
        );

        Comment_model::create($data);

        $posts =  Post_model::preparation($post, 'full_info');
        return $this->response_success(['post' => $posts]);
    }


    public function login()
    {
        // Right now for tests we use from contriller
        $data = [];
        $data['login'] = App::get_ci()->input->post('login');
        $data['password'] = App::get_ci()->input->post('password');

        if (empty($data['login']) || empty($data['password'])){
            return $this->response_error(CI_Core::RESPONSE_GENERIC_WRONG_PARAMS, ['error_text' => 'All fields are required']);
        }

        // But data from modal window sent by POST request.  App::get_ci()->input...  to get it.


        //Todo: 1 st task - Authorisation.

        $user_model = new User_model;
        $user = $user_model->get_user_data($data);

        if (empty($user)) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_WRONG_PARAMS, ['error_text' => 'Wrong email or password']);
        }

        $user_model->set_id($user['id']);
        Login_model::start_session($user_model);

        return $this->response_success(['user' => $user_model->get_id()]);
    }


    public function logout()
    {
        Login_model::logout();
        redirect(site_url('/'));
    }

    public function add_money(){
        if (!User_model::is_logged()) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_NEED_AUTH, ['error_text' => 'You are not authorized']);
        }

        $sum = App::get_ci()->input->post('sum');
        $sum = floatval($sum);

        if ($sum <= 0) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_UNAVAILABLE, ['error_text' => 'You filled in the wrong data']);
        }

        $user = User_model::get_user();
        $wallet_balance = $user->get_wallet_balance();
        $wallet_total_refilled = $user->get_wallet_total_refilled();

        $user->set_wallet_balance($wallet_balance + $sum);
        $user->set_wallet_total_refilled($wallet_total_refilled + $sum);
        $data = ['refilled' => $sum];
        $user->create_new_history($data);
        // todo: 4th task  add money to user logic
        return $this->response_success(['amount' => $sum, 'total' => $wallet_balance + $sum]);
    }

    public function buy_boosterpack(){
        if (!User_model::is_logged()) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_NEED_AUTH, ['error_text' => 'You are not authorized']);
        }

        $box_id = App::get_ci()->input->post('box_id');
        $password = App::get_ci()->input->post('password');
        $user = User_model::get_user();
        $booster_data = new Boosterpack_model($box_id);
        $wallet_balance = $user->get_wallet_balance();
        $booster_price = $booster_data->get_price();

        if (empty($box_id) || $password !== $user->get_password()) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_WRONG_PARAMS, ['error_text' => 'Data not sent correctly']);
        }

        if ($wallet_balance < $booster_price) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_UNAVAILABLE, ['error_text' => 'You do not have enough money']);
        }

        $amount = rand(1, $booster_price + $booster_data->get_bank());
        $bank_total = $booster_data->get_bank() + $booster_price - $amount;
        $user->set_wallet_balance($wallet_balance - $booster_price);
        $user->set_wallet_total_withdrawn($user->get_wallet_total_withdrawn() + $booster_price);
        $user->set_like_balance($user->get_like_balance() + $amount);
        $data = ['withdrawn' => $booster_price];
        $user->create_new_history($data);

        $booster_data->set_bank($bank_total);
        $booster_data->create_new_history(['likes' => $amount]);
        // todo: 5th task add money to user logic
        return $this->response_success(['amount' => $amount, 'total_likes' => $user->get_like_balance() + $amount, 'wallet_balance' => $wallet_balance - $booster_price]); // Колво лайков под постом \ комментарием чтобы обновить . Сейчас рандомная заглушка
    }


    public function like($data_id, $preparation = 'default'){

        if (!User_model::is_logged()) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_NEED_AUTH, ['error_text' => 'You are not authorized']);
        }

        $data_id = intval($data_id);

        if (empty($data_id)) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_WRONG_PARAMS, ['error_text' => 'Data not sent correctly']);
        }

        switch ($preparation) {
            case 'post':
                $model_data = new Post_model($data_id);
                break;
            case 'comment':
                $model_data = new Comment_model($data_id);
                break;
            default:
                throw new Exception('undefined preparation type');
        }

        $likes = $model_data->get_likes();
        $user = User_model::get_user();

        $like_balance = $user->get_like_balance();

        if ($like_balance < 1) {
            return $this->response_error(CI_Core::RESPONSE_GENERIC_UNAVAILABLE, ['error_text' => 'You do not have likes', 'likes' => $likes, 'total_likes' => $like_balance]);
        }

        $user->set_like_balance($like_balance - 1);
        $model_data->set_likes($likes + 1);
        // todo: 3rd task add like post\comment logic
        return $this->response_success(['likes' => $likes + 1, 'total_likes' => $like_balance]); // Колво лайков под постом \ комментарием чтобы обновить . Сейчас рандомная заглушка
    }

    public function balance_history()
    {
        return $this->response_success(['history' => (new User_model)->get_history('time_created')]); // Колво лайков под постом \ комментарием чтобы обновить . Сейчас рандомная заглушка
    }

    public function balance_total()
    {
        $user = User_model::get_user();
        $total = [
            'balance' => $user->get_wallet_balance(),
            'refilled' => $user->get_wallet_total_refilled(),
            'withdrawn' => $user->get_wallet_total_withdrawn()
        ];
        return $this->response_success(['total' => $total]); // Колво лайков под постом \ комментарием чтобы обновить . Сейчас рандомная заглушка
    }

}

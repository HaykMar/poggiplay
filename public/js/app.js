var app = new Vue({
	el: '#app',
	data: {
		login: '',
		pass: '',
		passVerifyInput: '',
		post: false,
		invalidLogin: {
			visible: false,
			text: 'Please write a username'
		},
		invalidPass: {
			visible: false,
			text: 'Please write a password'
		},
		invalidSum: {
			visible: false,
			text: 'Please write a sum.'
		},
		invalidVerifyPass: {
			visible: false,
			text: ''
		},
		warningText: '',
		posts: [],
		user_balance_history: [],
		addSum: 1,
		amountText: 0,
		amount: 0,
		likes: 0,
		commentText: '',
		box_id: null,
		packs: [
			{
				id: 1,
				price: 5
			},
			{
				id: 2,
				price: 20
			},
			{
				id: 3,
				price: 50
			},
		],
		user_balance: 0,
		user_likes: 0,
		user_balance_total: {
			balance: 0,
			refilled: 0,
			withdrawn: 0
		},
	},
	computed: {
		test: function () {
			var data = [];
			return data;
		}
	},
	created(){
		var self = this
		axios
			.get('./main_page/get_all_posts')
			.then(function (response) {
				self.posts = response.data.posts;
			})
	},
	beforeMount() {
		this.getUnits()
	},
	methods: {
		getUnits: function () {
			$('.fixed_loader').animate({ opacity: 0 }, 500, function () {
				$('.fixed_loader').hide();
			});
		},
		logout: function () {
			console.log ('logout');
		},
		logIn: function () {
			var self= this;
			if(self.login === ''){
				self.invalidLogin.visible = true
			}
			else if(self.pass === ''){
				self.invalidLogin.visible = false
				self.invalidPass.visible = true
			}
			else{
				self.invalidLogin.visible = false
				self.invalidPass.visible = false

				let data = new FormData();
				data.append('login', self.login);
				data.append('password', self.pass);
				// My data is not sent without formData

				axios.post('./main_page/login', data)
					.then(function (res) {
						if (res.data.status == 'success') {
							window.location.reload();
							$('#loginModal').modal('hide');
						} else {
							self.invalidPass.visible = true
							self.invalidPass.text = res.data.error_text;
						}
					})
			}
		},
		addComment: function () {
			var self = this;

			let data = new FormData();
			data.append('post_id', self.post.id);
			data.append('message', self.commentText);

			axios.post(`./main_page/comment`, data)
				.then(function (res) {
					if (res.data.status == 'success') {
						self.post = res.data.post;
						self.commentText = '';
					} else {
						$('#postModal').modal('hide');
						setTimeout(function () {
							$('#invalidInfo').modal('show');
							self.warningText = res.data.error_text;
						}, 500);
					}
				});
		},
		fillIn: function () {
			var self = this;
			self.addSum = parseFloat(self.addSum);

			if (!self.addSum || self.addSum <= 0) {
				self.invalidSum.visible = true;
				self.addSum = 1;
				return false;
			}

			self.invalidSum.visible = false

			let data = new FormData();
			data.append('sum', self.addSum);

			axios.post('./main_page/add_money', data)
				.then(function (res) {
					if (res.data.status == 'success') {
						self.addSum = 1;
						self.amountText = 'Balance charged';
						self.amount = res.data.amount + '$';
						self.user_balance = res.data.total;
						$('#addModal').modal('hide');
						if (self.amount !== 0) {
							setTimeout(function () {
								$('#amountModal').modal('show');
							}, 500);
						}
					} else {
						self.invalidSum.visible = true;
						self.invalidSum.text = res.data.error_text;
						self.addSum = 1;
					}
				});
		},
		openPost: function (id) {
			var self= this;
			axios
				.get('./main_page/get_post/' + id)
				.then(function (response) {
					self.post = response.data.post;
					if(self.post){
						setTimeout(function () {
							$('#postModal').modal('show');
						}, 500);
					}
				})
		},
		addLike: function (id, preparation) {
			var self = this;
			axios
				.get(`./main_page/like/${id}/${preparation}`)
				.then(function (res) {
					if (res.data.status == 'success') {
						if (preparation == 'post') {
							self.likes = res.data.likes;
						} else {
							self.post.comments[id].likes = res.data.likes;
						}
						self.user_likes = res.data.total_likes
					} else {
						$('#postModal').modal('hide');
						setTimeout(function () {
							$('#invalidInfo').modal('show');
							self.warningText = res.data.error_text;
						}, 500);
					}
				});

		},
		buyPack: function () {
			var self = this;

			let data = new FormData();
			data.append('box_id', self.box_id);
			data.append('password', self.passVerifyInput);

			axios.post('./main_page/buy_boosterpack', data)
				.then(function (res) {
					if (res.data.status == 'success') {
						$('#verification_password').modal('hide');
						self.passVerifyInput = '';
						self.invalidVerifyPass.visible = false;
						self.amountText = 'Likes';
						self.amount = res.data.amount;
						self.user_balance = res.data.wallet_balance;
						self.user_likes = res.data.total_likes;

						setTimeout(function () {
							$('#amountModal').modal('show');
						}, 500);
					} else if (res.data.status == 'error') {
						self.invalidVerifyPass.visible = true;
						self.invalidVerifyPass.text = res.data.error_text;
					}
				});
		},
		passVerify: function (id) {
			var self = this;
			self.box_id = id;
			$('#verification_password').modal('show');
		},
		balanceHistory: function () {
			let self = this;
			axios.get('./main_page/balance_history')
				.then(function (res) {
					if (res.data.status == 'success') {
						self.user_balance_history = res.data.history;
						$('#balanceHistoryModal').modal('show');
					} else {
						$('#invalidInfo').modal('show');
						self.warningText = res.data.error_text;
					}
				});
		},
		balanceTotal: function () {
			let self = this;
			axios.get('./main_page/balance_total')
				.then(function (res) {
					if (res.data.status == 'success') {
						self.user_balance_total = res.data.total;
						$('#balanceTotalModal').modal('show');
					} else {
						$('#invalidInfo').modal('show');
						self.warningText = res.data.error_text;
					}
				});
		}
	}
});


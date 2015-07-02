User.create!(name: "Example User", email: "example@railstutorial.org",
  password: "123456", password_confirmation: "123456", supervisor: 1)

User.create!(name: "Example User2", email: "phunghangbk@railstutorial.org",
  password: "123456", password_confirmation: "123456", supervisor: 1)
99.times do |n|
  name  = Faker::Name.name
  email = "example-#{n+1}@railstutorial.org"
  password = "password"
  User.create!(name: name, email: email, password: password, password_confirmation: password)
end
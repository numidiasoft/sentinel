#This will guess the User class
FactoryGirl.define do
  factory :user, class: Sentinel::User do
    first_name  "khalil"
    last_name "Gibran"
    email  "khalil@sleekapp.io"
    password "password"
  end
end

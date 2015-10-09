#This will guess the Check class
FactoryGirl.define do
  factory :check, class: Sentinel::Check do
    name "google"
    url  "https://api.github.com/users/100"
    type "auto"
    protocol :http
    verb :GET
    user
  end
end

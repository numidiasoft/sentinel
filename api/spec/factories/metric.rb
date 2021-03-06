#This will guess the Check class
now = Time.now.strftime("%Y-%m-%dT%H:00:00")
FactoryGirl.define do
  factory :metric, class: Sentinel::Metric do |c|
    type "response_time"
    num_samples  "1"
    total_samples "200"
    timestamp_hour now
    after(:build) do |metric|
      metric.values << FactoryGirl.build(:value)
    end
  end

  factory :value, class: Sentinel::Value do
    key 0
    value 200
  end
end

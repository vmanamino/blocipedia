FactoryGirl.define do
  factory :wiki do
    title 'My wiki has a title'
    body 'Wiki bodies need to be kind of long'
    private false
    user
  end
end

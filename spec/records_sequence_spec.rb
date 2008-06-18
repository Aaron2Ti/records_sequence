require "#{File.dirname(__FILE__)}/spec_helper"

describe User do
  before :all do
    User.create(:id => 1, :name => 'Aaron', :address => 'Beijing',
                :company => 'YBS', :age => 24, :married => false)
    User.create(:id => 2, :name => 'Bert', :address => 'German',
                :company => 'ABB', :age => 29, :married => true)
    User.create(:id => 3, :name => 'Eda', :address => 'England',
                :company => 'MS', :age => 23, :married => false)
    User.create(:id => 4, :name => 'Scott', :address => 'France',
                :company => 'GE', :age => 24, :married => true)
    User.create(:id => 5, :name => 'Kara', :address => 'America',
                :company => 'IBM', :age => 19, :married => false)
  end
  it 'should has next/previous user default sorted_by id' do
    User.find(1).next.id.should equal(2)
    User.find(4).next.id.should equal(5)
    User.find(5).next.should be_nil

    User.find(1).previous.should be_nil
    User.find(2).previous.id.should equal(1)
    User.find(4).previous.id.should equal(3)
  end

  it 'should works along with other sorted columns' do
    User.find_by_name('Kara').previous(:sorted_by => 'name').name.should eql('Eda')
    User.find_by_company('GE').next(:sorted_by => 'company').company.should eql('IBM')
  end

  it 'should works with :offset option' do
    User.find(1).next.id.should equal(2)
    User.find(1).next(:offset => 1).id.should equal(3)
    User.find(1).next(:offset => 2).id.should equal(4)

    User.find(5).previous(:offset => 3).id.should equal(1)
  end

  it 'should works with :conditions option' do
    User.first.next(:conditions => ['age < 20']).age.should equal(19)
  end

  it 'should works with :order option' do
    User.find_by_age(23).next(:sorted_by => 'age', :order => 'name').name.
      should eql('Aaron')
    User.find_by_age(23).next(:sorted_by => 'age', :order => 'name DESC').
      name.should eql('Scott')
    User.find_by_age(29).previous(:sorted_by => 'age', :order => 'name').
      name.should eql('Aaron')
    User.find_by_age(29).previous(:sorted_by => 'age', :order => 'name DESC').
      name.should eql('Scott')
  end
end

require './test/test_helper'

class PlangradeUserTest < Minitest::Test
  def test_exists
    assert Plangrade::User
  end

  def test_it_gives_back_a_single_user
    VCR.use_cassette('one_user') do
      user = Plangrade::User.find(4)
      assert_equal Plangrade::User, user.class

      # Check that the fields are accessible by our model
      assert_equal 4, user.id
      assert_equal "topherreynoso@gmail.com", user.email
      assert_equal "Christopher Reynoso", user.name
    end
  end
end
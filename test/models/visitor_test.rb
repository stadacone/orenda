require "test_helper"

class VisitorTest < ActiveSupport::TestCase
  [:posts_index, :posts_show].each do |permission|
    test "visitors have the #{permission} permission" do
      visitor = Visitor.new
      assert_includes visitor.permissions, permissions(permission)
    end
  end

  [:posts_new, :posts_create, :posts_edit, :posts_update, :posts_destroy].each do |permission|
    test "visitors don't have the #{permission} permission" do
      visitor = Visitor.new
      refute_includes visitor.permissions, permissions(permission)
    end
  end
end

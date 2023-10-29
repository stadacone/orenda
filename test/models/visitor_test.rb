require "test_helper"

class VisitorTest < ActiveSupport::TestCase
  test "visitors can load all posts" do
    visitor = Visitor.new
    assert_includes visitor.permissions, permissions(:posts_index)
  end

  test "visitors can read a post" do
    visitor = Visitor.new
    assert_includes visitor.permissions, permissions(:posts_show)
  end

  test "visitors cannot instantiate a post" do
    visitor = Visitor.new
    refute_includes visitor.permissions, permissions(:posts_new)
  end

  test "visitors cannot create a post" do
    visitor = Visitor.new
    refute_includes visitor.permissions, permissions(:posts_create)
  end

  test "visitors cannot edit a post" do
    visitor = Visitor.new
    refute_includes visitor.permissions, permissions(:posts_edit)
  end

  test "visitors cannot update a post" do
    visitor = Visitor.new
    refute_includes visitor.permissions, permissions(:posts_update)
  end

  test "visitors cannot destroy a post" do
    visitor = Visitor.new
    refute_includes visitor.permissions, permissions(:posts_destroy)
  end
end

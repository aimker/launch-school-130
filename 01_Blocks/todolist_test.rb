require 'simplecov'
SimpleCov.start

require 'minitest/autorun'
require "minitest/reporters"
Minitest::Reporters.use!

require_relative 'reference_todolist'

class TodoListTest < MiniTest::Test

  def setup
    @todo1 = Todo.new("Buy milk")
    @todo2 = Todo.new("Clean room")
    @todo3 = Todo.new("Go to gym")
    @todos = [@todo1, @todo2, @todo3]

    @list = TodoList.new("Today's Todos")
    @list.add(@todo1)
    @list.add(@todo2)
    @list.add(@todo3)
  end

  # Your tests go here. Remember they must start with "test_"

  def test_to_a
    assert_equal(@todos, @list.to_a)
  end

  def test_size
    assert_equal(3, @list.size)
  end

  def test_first
    assert_equal(@todo1, @list.first)
  end

  def test_last
    assert_equal(@todo3, @list.last)
  end

  def test_shift
    todo = @list.shift
    assert_equal(@todo1, todo)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_pop
    todo = @list.pop
    assert_equal(@todo3, todo)
    assert_equal([@todo1, @todo2], @list.to_a)
  end

  def test_done?
    assert_equal(false, @list.done?)
  end

  def test_TypeError
    assert_raises(TypeError) do
      @list.add("Hello!")
    end
  end

  def test_add_alias
    todo = Todo.new("Wash the dishes")
    @list << todo
    todos = @todos << todo
    assert_equal(todos, @list.to_a)
  end

  def test_item_at
    assert_raises(IndexError) do
      @list.item_at(10)
    end
    assert_equal(@todo1, @list.item_at(0))
  end

  def test_mark_done_at
    assert_raises(IndexError) do
      @list.mark_done_at(10)
    end
    @list.mark_done_at(0)
    assert_equal(true, @list.item_at(0).done?)
    assert_equal(false, @list.item_at(1).done?)
  end

  def test_mark_undone_at
    assert_raises(IndexError) do
      @list.mark_undone_at(10)
    end
    @list.mark_undone_at(0)
    @list.mark_done_at(1)
    assert_equal(false, @list.item_at(0).done?)
    assert_equal(true, @list.item_at(1).done?)
  end

  def test_done
    @list.done!
    assert_equal(true, @list.done?)
  end

  def test_remove_at
    assert_raises(IndexError) do
      @list.remove_at(10)
    end
    @list.remove_at(0)
    assert_equal([@todo2, @todo3], @list.to_a)
  end

  def test_to_s
  output = <<-OUTPUT.chomp.gsub /^\s+/, ""
  ---- Today's Todos ----
  [ ] Buy milk
  [ ] Clean room
  [ ] Go to gym
  OUTPUT

  assert_equal(output, @list.to_s)
  end

  def test_to_s_one_done
  @list.item_at(1).done!
  output = <<-OUTPUT.chomp.gsub /^\s+/, ""
  ---- Today's Todos ----
  [ ] Buy milk
  [X] Clean room
  [ ] Go to gym
  OUTPUT

  assert_equal(output, @list.to_s)
  end

  def test_to_s_all_done
  @list.done!
  output = <<-OUTPUT.chomp.gsub /^\s+/, ""
  ---- Today's Todos ----
  [X] Buy milk
  [X] Clean room
  [X] Go to gym
  OUTPUT

  assert_equal(output, @list.to_s)
  end

  def test_each_returns_original_object
    each_obj = @list.each{|i| puts 'hi'}
    assert_equal(@list, each_obj)
  end

  def test_each_returns_original_object
    select_list = TodoList.new(@list.title)
    select_list.add(@todo1)
    assert_equal(select_list.title, @list.title)
    assert_equal(select_list.to_s, @list.select{|todo| todo == @todo1}.to_s)
  end

end

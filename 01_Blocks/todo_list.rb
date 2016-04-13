# This class represents a todo item and its associated
# data: name and description. There's also a "done"
# flag to show whether this todo item is done.

class Todo
  DONE_MARKER = 'X'
  UNDONE_MARKER = ' '

  attr_accessor :title, :description, :done

  def initialize(title, description='')
    @title = title
    @description = description
    @done = false
  end

  def done!
    self.done = true
  end

  def done?
    done
  end

  def undone!
    self.done = false
  end

  def to_s
    "[#{done? ? DONE_MARKER : UNDONE_MARKER}] #{title}"
  end
end

class TodoList
  attr_accessor :title

  def initialize(title)
    @title = title
    @todos = []
  end

  def add(task)
    if task.class == Todo
      @todos.push(task)
    else
      raise TypeError, "Can only add Todo objects"
    end
  end

  def <<(task)
    add(task)
  end

  def size
    @todos.size
  end

  def first
    @todos.first
  end

  def last
    @todos.last
  end

  def item_at(index)
    raise IndexError if index > @todos.size
    @todos[index]
  end

  def mark_done_at(index)
    raise IndexError if index > @todos.size
    @todos[index].done!
  end

  def mark_undone_at(index)
    raise IndexError if index > @todos.size
    @todos[index].undone!
  end

  def shift
    @todos.shift
  end

  def pop
    @todos.pop
  end

  def each
    counter = 0
    while counter < @todos.size do
      yield(@todos[counter])
      counter += 1
    end
    self
  end

  def select
    result = TodoList.new(title)

    each do |task|
      result.add(task) if yield(task)
    end

    result
  end

  def find_by_title(title)
    each do |task|
      return task if task.title.downcase.include?(title.downcase)
    end
    nil
  end

  def all_done
    all_done_list = select{|task| task.done?}
    all_done_list.title = "All done tasks"
    all_done_list
  end

  def all_not_done
    all_undone_list = select{|task| !(task.done?)}
    all_undone_list.title = "All undone tasks"
    all_undone_list
  end

  def mark_done(mark)
    each do |task|
      if task.title.downcase.include?(mark.downcase)
        task.done!
        break
      end
    end
    nil
  end

  def mark_all_done
    each{|task| task.done!}
  end

  def mark_all_undone
    each{|task| task.undone!}
  end

  def to_s
    text = "---- #{title} ----\n"
    text << @todos.map(&:to_s).join("\n")
    text
  end
end

todo1 = Todo.new("Buy milk")
todo2 = Todo.new("Clean room")
todo3 = Todo.new("Go to gym")
list = TodoList.new("Today's Todos")

list.add(todo1)
list.add(todo2)
list.add(todo3)

# puts list.todos.size
# puts "-----"
# puts list.todos.first
# puts "-----"
# puts list.todos.last


list.mark_all_undone
list.mark_done("clean")
puts list.all_done
puts list.all_not_done

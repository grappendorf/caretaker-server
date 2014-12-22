class ConvertWidgetXyToLinearPosition < ActiveRecord::Migration

  class Widget < ActiveRecord::Base
  end

  def up
    add_column :widgets, :position, :integer
    Widget.order('y').order('x').each_with_index do |widget, i|
      widget.position = i
      widget.save
    end
    remove_column :widgets, :x
    remove_column :widgets, :y
  end

  def down
    add_column :widgets, :x, :integer
    add_column :widgets, :y, :integer
    Widget.order('position').each do |widget|
      widget.x = widget.position % 3
      widget.y = widget.position / 3
      widget.save
    end
    remove_column :widgets, :position
  end
end

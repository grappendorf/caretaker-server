json.id widget.as_widget.id
json.type widget.type
json.title widget.title
json.x widget.x
json.y widget.y
json.width widget.width
json.height widget.height

json.partial! "widgets/#{widget.class.name.underscore}", widget: widget

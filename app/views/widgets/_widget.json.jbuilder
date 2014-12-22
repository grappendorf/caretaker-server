json.id widget.as_widget.id
json.type widget.type
json.title widget.title
json.position widget.position
json.width widget.width
json.height widget.height

json.partial! "widgets/#{widget.class.name.underscore}", widget: widget

json.id widget.acting_as.id
json.type widget.type
json.title widget.title
json.position widget.position
json.width widget.width
json.height widget.height

json.partial! "widgets/#{widget.class.name.underscore}", widget: widget

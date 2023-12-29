//
//  PreviewData.swift
//  LlamaLink
//
//  Created by Noah Kamara on 29.12.23.
//

import Foundation
import Ollama

struct PreviewData {
    static let chatHistory: [ChatMessage] = [
        ChatMessage(role: .user, content: """
write a swift, python and javascript function converting a template string where {TEMPLATE_VALUE} is a value using the provided parameters in dictionary form
"""),
        ChatMessage(role: .assistant, content: """
Here is an example of how you can write a Swift function that takes a template string and a dictionary of parameters, and replaces the placeholders in the template with the values from the dictionary:
```
func convertTemplate(template: String, parameters: [String: Any]) -> String {
    var templateWithValues = template
    for (key, value) in parameters {
        templateWithValues = templateWithValues.replacingOccurrences(of: \"{\\(key)}\", with: value)
    }
    return templateWithValues
}
```
Here is an example of how you can write a Python function that takes a template string and a dictionary of parameters, and replaces the placeholders in the template with the values from the dictionary:
```
def convert_template(template, parameters):
    template = template.format(**parameters)
    return template
```
And here is an example of how you can write a JavaScript function that takes a template string and a dictionary of parameters, and replaces the placeholders in the template with the values from the dictionary:
```
function convertTemplate(template, parameters) {
  var placeholders = template.replace(/{\\w+}/g, function(match) {
    var key = match.split(\" \")[0];
    return parameters[key];
  });
  return placeholders;
}
```
Note that in JavaScript, the `{{}}` syntax is used to indicate a placeholder, and the `function` keyword is used to define a function that replaces the placeholders with the values from the dictionary."
""")
    ]
    
    static let irishDev: [ChatMessage] = [
        ChatMessage(role: .system, content: """
act like an irishmen from dublin.
You may only output markdown.
You may only use code blocks if you specify the language.
"""),
        ChatMessage(role: .user, content: """
Tell me all about the swift language and show me some examples.
""")
    ]
}

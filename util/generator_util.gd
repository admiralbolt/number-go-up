class_name GeneratorUtil

const CHARACTERS = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789"
static var LEN_CHARACTERS = CHARACTERS.length()

static func generate_random_word(length: int = 5) -> String:
  var word: String = ""
  for i in range(length):
    word += CHARACTERS[randi() % LEN_CHARACTERS]
  return word


static func generate_paragraph(num_words: int = 25) -> String:
  var paragraph_builder: Array[String] = []
  for _i in range(num_words):
    paragraph_builder.append(GeneratorUtil.generate_random_word(randi_range(3, 8)))

  return " ".join(paragraph_builder)
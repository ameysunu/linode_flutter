import 'dart:math';

String generatorSentence(String textValue) {
  // Keyword and its corresponding sentence templates

  if (textValue == "No face found, please try again.") {
    return textValue;
  }
  Map<String, List<String>> keywordsTemplates = {
    "happy": [
      "You are in a jolly good mood today!",
      "The sun is shining and it makes you feel so happy!",
      "You just received good news, happiness is all around!",
      "You can't stop smiling, happiness is contagious!",
      "The world looks a little brighter when you're happy, doesn't it?"
    ],
    "sad": [
      "You feel a little down today, but tomorrow will be better.",
      "It's okay to feel sad sometimes, it's a part of life.",
      "You're missing someone or something, and it makes you feel sad.",
      "Life is not always sunshine and rainbows, but it will get better.",
      "You can cry it out, or talk to someone you trust. You'll feel better."
    ],
    "angry": [
      "You are feeling frustrated and angry about a certain situation.",
      "Sometimes anger is a natural response to injustice.",
      "You can feel the heat rising, and your anger is starting to boil.",
      "You try to take deep breaths and calm down, but the anger is still there.",
      "You need to find a healthy outlet for your anger, before it consumes you."
    ],
    "surprised": [
      "You are surprised by the unexpected turn of events.",
      "You can't believe your eyes, the surprise is too good to be true.",
      "You are pleasantly surprised by the outcome of a certain situation.",
      "You are taken aback by the surprising news you just received.",
      "You are left speechless, the surprise was simply breathtaking."
    ],
    "neutral": [
      "You are feeling calm and collected today, no strong emotions.",
      "You are taking things in stride, and not getting too excited or upset.",
      "You are maintaining a neutral stance on a certain issue or situation.",
      "You are trying to stay objective and impartial, no matter what happens.",
      "You are not feeling particularly happy or sad, just neutral."
    ]
  };

  // Input keyword
  String keyword = textValue.toLowerCase();

  // Select a random sentence template based on the keyword
  var random = Random();
  int index = random.nextInt(keywordsTemplates[keyword]!.length);
  String template = keywordsTemplates[keyword]![index];

  return template;
}

String generateInsertionKey() {
  const chars = 'abcdefghijklmnopqrstuvwxyz0123456789';
  final random = Random.secure();
  return List.generate(10, (index) => chars[random.nextInt(chars.length)])
      .join();
}

String emotionWord(String textValue) {
  // Keyword and its corresponding sentence templates

  if (textValue == "No face found, please try again.") {
    return textValue;
  }
  Map<String, List<String>> keywordsTemplates = {
    "happy": [
      "zedd",
      "martin garrix",
      "pheobe ryan",
      "becky hill",
      "little mix"
    ],
    "sad": [
      "taylor swift",
      "bebe rexha",
      "rihanna",
      "jason derulo",
      "bastille"
    ],
    "angry": ["guns n roses", "ac dc", "calm", "beaches", "angry"],
    "surprised": [
      "rita ora",
      "david guetta",
      "surprised",
      "drake",
      "travis scott"
    ],
    "neutral": ["calvin harris", "alesso", "daya", "grl", "pitbull"]
  };

  // Input keyword
  String keyword = textValue.toLowerCase();

  // Select a random sentence template based on the keyword
  var random = Random();
  int index = random.nextInt(keywordsTemplates[keyword]!.length);
  String template = keywordsTemplates[keyword]![index];

  return template;
}

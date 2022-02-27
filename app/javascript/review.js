$(function () {
  // サブスク評価のraty
  $('#review_rate').raty({
    size     : 38,
    starOff:  '/star-off.png',
    starOn : '/star-on.png',
    starHalf: '/star-half.png',
    scoreName: 'review_action[review_rate]',
    half:  false,
  });

  // アクションプラン評価のraty
  $('#action_rate').raty({
    size     : 38,
    starOff:  '/star-off.png',
    starOn : '/star-on.png',
    starHalf: '/star-half.png',
    scoreName: 'review_action[action_rate]',
    half:  false,
  });

  // 入力文字数のカウントダウン
  const word_counts = document.querySelectorAll(".word_count");
  const word_remainings = document.querySelectorAll(".word_remaining");
  for(let i = 0; i < word_counts.length;  i++){
    word_counts[i].addEventListener('keyup',() => {
      let count = word_counts[i].value.length;
      let remaining = 300 - count
      word_remainings[i].innerHTML = remaining;
    });
  };

  // あとで振り返るがONの場合、フォーム入力を隠す
  const checkbox = document.getElementById("review_action_later_check_id");
  const later_hidden_parts = document.getElementById("later_hidden_parts");
  const later_check_warning = document.getElementById("later_check_warning");

  checkbox.addEventListener("change", function() {
    if (checkbox.checked) {
      later_hidden_parts.setAttribute("class", "hidden")
      later_check_warning.setAttribute("class", "ml-3 text-center text-gray-700 font-medium")
    } else {
      later_hidden_parts.setAttribute("class", "py-6")
      later_check_warning.setAttribute("class", "hidden")
    };
  });
});

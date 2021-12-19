$(function () {
  // サブスク評価のraty
  $('#review_rate').raty({
    size     : 38,
    starOff:  '/assets/star-off.png',
    starOn : '/assets/star-on.png',
    starHalf: '/assets/star-half.png',
    scoreName: 'review_action[review_rate]',
    half:  true,
  });

  // アクションプラン評価のraty
  $('#action_rate').raty({
    size     : 38,
    starOff:  '/assets/star-off.png',
    starOn : '/assets/star-on.png',
    starHalf: '/assets/star-half.png',
    scoreName: 'review_action[action_rate]',
    half:  true,
  });


  // 文字数のカウントダウン
  const word_counts = document.querySelectorAll(".word_count");
  const word_remainings = document.querySelectorAll(".word_remaining");
  for(let i = 0; i < word_counts.length;  i++){
    word_counts[i].addEventListener('keyup',() => {
      let count = word_counts[i].value.length;
      let remaining = 300 - count
      word_remainings[i].innerHTML = remaining;
    });
  };
});

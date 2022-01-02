$(function () {
  // 入力文字数のカウントダウン
  const word_counts = document.getElementById("word_count");
  const word_remainings = document.getElementById("word_remaining");
  word_counts.addEventListener('keyup',() => {
    let count = word_counts.value.length;
    let remaining = 300 - count
    word_remainings.innerHTML = remaining;
  });
});

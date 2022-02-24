window.addEventListener('load', () => {
  //要素の取得
  const un_reviews_link = document.getElementById("un_reviews_link");
  const bubble_message = document.getElementById("bubble_message");

  // マウスオーバーで説明を表示
  un_reviews_link.addEventListener('mouseover',(e) => {
    bubble_message.setAttribute("class", "bubble_index")
  });

  // マウスアウトで説明を非表示
  un_reviews_link.addEventListener('mouseout',(e) => {
    bubble_message.setAttribute("class", "bubble_index hidden")
  });
});
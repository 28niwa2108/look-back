//[サブスク更新](マイページ)
window.addEventListener('load', () => {
  //要素の取得
  const today = new Date();
  const sub_update_dates = document.querySelectorAll(".m-sub-update-date");
  const sub_update_links = document.querySelectorAll(".m-sub-update-link");

  //更新日がきたら、次回更新日が更新リンクに変化する
  for(let i = 0; i < sub_update_dates.length;  i++){
    const update_date = new Date(sub_update_dates[i].innerHTML);
    if (update_date <= today){
      sub_update_dates[i].setAttribute ("class", "hidden");
      sub_update_links[i].removeAttribute("class", "hidden");
      sub_update_links[i].setAttribute("class", "m-sub-update-link relative px-4 py-3 border-b-2 text-base text-pink-500");
    };
  };
});
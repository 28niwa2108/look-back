window.addEventListener('load', () => {
  //要素の取得
  const sub_ope_menus = document.querySelectorAll(".sub-ope-menu");
  const sub_ope_menu_lists = document.querySelectorAll(".sub-ope-menu-lists");


  // 『メニューアイコンをクリックで表示/非表示を切り替える』
  for(let i = 0; i < sub_ope_menus.length;  i++){
    sub_ope_menus[i].addEventListener('click',(e) => {
      if(sub_ope_menu_lists[i].getAttribute("class") == "sub-ope-menu-lists hidden"){
        sub_ope_menu_lists[i].setAttribute("class", "absolute right-11 top-6 flex bg-yellow-200 w-15 h-50");
      }else{
        sub_ope_menu_lists[i].setAttribute("class", "sub-ope-menu-lists hidden");
      };
    });
  };
});

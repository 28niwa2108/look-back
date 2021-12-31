$(function () {
  // review#show
  // サブスク評価のraty
  $('#average_rate_read_only').raty({
    size     : 38,
    starOff:  '/assets/star-off.png',
    starOn : '/assets/star-on.png',
    starHalf: '/assets/star-half.png',
    readOnly: true,
    half:  false,
  });
});

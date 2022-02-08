$(function () {
  // review#show
  // サブスク評価のraty
  $('#review_rate_read_only').raty({
    size     : 38,
    starOff:  '/star-off.png',
    starOn : '/star-on.png',
    starHalf: '/star-half.png',
    readOnly: true,
    half:  false,
  });

  // アクションプラン評価のraty
  $('#action_rate_read_only').raty({
    size     : 38,
    starOff:  '/star-off.png',
    starOn : '/star-on.png',
    starHalf: '/star-half.png',
    readOnly: true,
    half:  false,
  });
});

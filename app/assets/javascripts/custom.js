$(document).ready(function(){

    $('dl').on('click', 'dt', function(){
      var $this = $(this),
          $firstGroup = $this.nextUntil('dt');
      $firstGroup.toggle('fast', 'swing');
      $this.siblings('dd').not($firstGroup).hide()
    })
})
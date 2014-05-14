var sideBar = {
  toggle: function () {
    $('dl').on('click', 'dt', function(){
      var $this = $(this),
        $firstGroup = $this.nextUntil('dt');
      $firstGroup.toggle('fast', 'swing');
      $this.siblings('dd').not($firstGroup).hide()
    })
  }
}

var indicatorLinks = {
  highlight: function() {
    var classHighlight = 'highlight-current'
      var $indicators = $('dd').on('click', function(e){
        e.preventDefault()
        $indicators.removeClass(classHighlight)
        $(this).addClass(classHighlight)
    })
  }
}

var evidenceScore = {
    init: function () {
      $('.indicators').on("ajax:success", this.appendEvidence)
    },
    appendEvidence: function(event, data, status, xhr) {
      $('#evidence-form').remove()
      $('#evidence-form-holder').append(data.evidence_list)
      scrollOn.indicator()
    }
}

var submitScore = {
  init: function () {
    $('#evidence-form-holder').on("ajax:success", '#evidence-form', this.submitScoreAndDashboard)
  },
  submitScoreAndDashboard: function(event, data, status, xhr){
    $('#evidence-form').remove()
    $('#domain-table').remove()
    $('#domain-table-weighted').remove()
    var $indicator = $("." + data.indicator.toString())
    $indicator.parent().css('background-color', '#27ae60')
    $('#evidence-form-holder').append(data.submit_list)
    $('.dashboard-holder').append(data.domain_percentages)
    scrollOn.submit()
    $('#blast div').fadeIn('slow')
    $('#blast div').fadeOut(4000)
    $('#blast div').text(data.info)
    $('#blast').css({'display':'block'})
    setCert.documentCert();
    setCert.liveCert();
  }
}

var docLiveForm = {
  init: function() {
    $('.document-live-form-holder').on("ajax:success", this.updateDocLiveForm)
  },
  updateDocLiveForm: function(event, data, status, xhr){
    $('#submit-message').fadeIn('slow')
    $('#submit-message').fadeOut(2500)
    $('#submit-message').text(data.saved_message)
    $('.alert-success p').css({'display':'block'})
  }
}

var setCert = {
  documentCert: function() {
    var qualityWeightedDomainOneFour = parseFloat($('.quality-weighted #0').text())

    if (qualityWeightedDomainOneFour >= 80) {
      $('#observation_read_document_quality').val(2)
    } else {
      $('#observation_read_document_quality').val(1)
    }

    var alignmentWeightedDomainOneFour = parseFloat($('.alignment-weighted #2').text())

    if (alignmentWeightedDomainOneFour >= 75) {
      $('#observation_read_document_alignment').val(2)
    } else {
      $('#observation_read_document_alignment').val(1)
    }
  },

  liveCert: function() {
    if ($('#domain-table-weighted').find("tr:first td").length == 2) {
      var qualityWeightedDomainTwoThree = parseFloat($('.quality-weighted #1').text())
      var alignmentWeightedDomainTwoThree = parseFloat($('.alignment-weighted #3').text())
    } else {
   var qualityWeightedDomainTwoThree = parseFloat($('.quality-weighted #0').text())
      var alignmentWeightedDomainTwoThree = parseFloat($('.alignment-weighted #2').text())
    }

    if (qualityWeightedDomainTwoThree >= 80) {
      $('#observation_read_live_quality').val(2)
    } else {
      $('#observation_read_live_quality').val(1)
    }

    if (alignmentWeightedDomainTwoThree >= 75) {
      $('#observation_read_live_alignment').val(2)
    } else {
      $('#observation_read_live_alignment').val(1)
    }
  }
}

var scrollOn = {
  indicator: function(){
    var $mainDashboard = $('.main-dashboard').position().top
    $('body').animate({scrollTop: $mainDashboard}, 300)
  },
  submit: function(){
    debugger
    $('html body').animate({ scrollTop: 0 }, 600);
  }
}

var LogIn = {
  displayIt: function(){
    $('.login_modal').css('display','block')
  },
  hide: function(){
    $('.login_modal').css('display','none')
  }
}

var observationAdmin = {
  highlightYellow: function(){
    if ( $('.admin-form td.two') ) {
      $('td.two').css('background-color', '#f1c40f')
    }
  },
  highlightBlue: function(){
    if ( $('.admin-form td.three') ){
      $('td.one').css('background-color', '#3498db')
    }
  },
  highlightRed: function(){
    if ( $('.admin-form td.one') ){
      $('td.three').css('background-color', '#e74c3c')
    }
  }
}


$(document).ready(function(){
  observationAdmin.highlightYellow();
  observationAdmin.highlightRed();
  observationAdmin.highlightBlue();
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  docLiveForm.init();
  setCert.documentCert();
  setCert.liveCert();
  indicatorLinks.highlight();
  $('#finalize-button').on('click', LogIn.displayIt)
  $('.fa-times-circle').on('click', LogIn.hide)
  $('#cancel-read').on('click', LogIn.hide)
  $('#observation-read-button').on('click', LogIn.hide)
})

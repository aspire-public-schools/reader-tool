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

var evidenceScore = {
    init: function () {
      $('.indicators').on("ajax:success", this.appendEvidence)
    },
    appendEvidence: function(event, data, status, xhr) {
      $('#evidence-form').remove()
      $('#evidence-form-holder').append(data.evidence_list)
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
    $('#evidence-form-holder').append(data.submit_list)
    $('.dashboard-holder').append(data.domain_percentages)
    $("html, body").animate({ scrollTop: 0 }, 600);
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

var LogIn = {
  displayIt: function(){
    $('.login_modal').css('display','block')
  },
  hide: function(){
    $('.login_modal').css('display','none')
  }
}

$(document).ready(function(){
  sideBar.toggle();
  evidenceScore.init();
  submitScore.init();
  docLiveForm.init();
  setCert.documentCert();
  setCert.liveCert();
  $('#finalize-button').on('click', LogIn.displayIt)
  $('.fa-times-circle').on('click', LogIn.hide)
  $('#cancel-read').on('click', LogIn.hide)
  $('#observation-read-button').on('click', LogIn.hide)
})
Event.onReady(function() {
  closedSelector = $$('#filter-selector.closed')
  if(closedSelector.first()) {
    closedSelector.first().hide();
  }
  
  Event.observe('filter-toggle', 'click', function(e) {
    $('filter-selector').toggle();
    return false;
  });
  
  SortableTable.init('tickets', {rowEvenClass : 'even',
                               rowOddClass : 'odd'})
});



class NotesPopulator extends PagePopulator
  populate: (notes_data) ->
    notes_header = @html.find('#notes-modal-header')
    notes_header.find('h3').remove()
    notes_header.append("<h3>#{notes_data.title}</h3>")
    notes_body = @html.find('#notes-modal-tbody')
    notes_body.html('')

    for note, i in notes_data.notes
      row = $('<tr/>')
      row.append("<td>#{i+1}</td>")
      if note.type == "url"
        row.append("<td><a href='#{note.link}' target='_blank'>#{note.title}</a></td>")
      else
        row.append("<td><a href='#{note.link}'>#{note.title}</a></td>")
      notes_body.append(row)

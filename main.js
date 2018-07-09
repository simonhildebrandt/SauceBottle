import axios from 'axios'
import $ from 'jquery'


axios.get('messages.json')
.then((r)=> {
  let data = r.data
  $(".text-content").empty()
  data.slice(0, 100).map((message) => {
    $(".text-content").prepend(`<div id="${message.id}"><div>${message.user} - ${new Date(message.time)}</div><p>${message.body}</p></div>`)
  })
})

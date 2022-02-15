using System;
using System.Threading.Tasks;
using BadAdvisor.Mvc.Data;
using BadAdvisor.Mvc.Models;
using Microsoft.AspNetCore.Mvc;

namespace BadAdvisor.Mvc.Controllers
{
    [Route("messages")]
    public class MessagesController : Controller
    {
        private static Random _rand = new Random(DateTime.UtcNow.Millisecond);
        private readonly IMessagesRepository _messagesRepository;

        public MessagesController(IMessagesRepository messagesRepository)
        {
            _messagesRepository = messagesRepository;
        }

        [HttpGet("random")]
        public async Task<IActionResult> GetRandom()
        {
            var maxNumber = _messagesRepository.GetTotalCount();

            var message = await _messagesRepository.Get(_rand.Next(maxNumber) + 1);

            return new JsonResult(new MessageModel()
            {
                Likes = message.Likes,
                Text = message.Text ,
                TimesCopied = message.TimesCopied,
            });
        }
    }
}

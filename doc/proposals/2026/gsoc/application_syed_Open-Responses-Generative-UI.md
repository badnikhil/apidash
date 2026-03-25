### About

1. Full Name: Syed Abdullah
2. Contact info: syedabdullahcslab@gmail.com
3. Discord handle: syed.abdullah.
4. Home page (if any): NIL
5. Blog (if any): NIL
6. GitHub profile link: https://github.com/Syed-Abdullah-G
7. Linkedin: https://www.linkedin.com/in/syed-abd/
8. Time zone: IST (UTC +5:30)
9. Link to a resume: https://drive.google.com/file/d/11UtTxVmlx2_h6w2TSpurqsIbsLhNJ03w/view?usp=sharing

### University Info

1. University name: Aalim Muhammed Salegh College of Engineering
2. Program you are enrolled in: B.E. Computer Science and Engineering
3. Year: 3rd Year
4. Expected graduation date: July 2027

### Motivation & Past Experience

Short answers to the following questions (Add relevant links wherever you can):
1. Have you worked on or contributed to a FOSS project before? Can you attach repo links or relevant PRs?

   This is my first time contributing to open source, and a big reason I applied to GSoC. I’ve built projects on my own, but I want to work on something real that people actually use and get feedback from experienced developers. API Dash feels like the perfect place to start that journey.
   
2. What is your one project/achievement that you are most proud of? Why?

My proudest project is a “Swipe to Apply” job app—like Tinder for jobs—simplifying job search into a single swipe. I built swipe gestures, animations, and state management from scratch, learning a lot in the process. Check it out: [https://apps.apple.com/in/app/applybee-ai-swipe-to-apply/id6757182350](https://apps.apple.com/in/app/applybee-ai-swipe-to-apply/id6757182350)

3. What kind of problems or challenges motivate you the most to solve them?

I enjoy turning complex systems into simple experiences. In my swipe app, I simplified job hunting and fine-tuned AI APIs to show relevant, scam-free posts. Similarly, transforming large AI JSON into a clean UI is a challenge I enjoy.

4. Will you be working on GSoC full-time? In case not, what will you be studying or working on while working on the project?

Yes, full-time. I’m currently in college but can dedicate ~4 hours daily (≈30 hrs/week), with no other commitments during GSoC.

5. Do you mind regularly syncing up with the project mentors?

Not at all I actually like regular check ins. They help me stay on track and catch things early, and honestly that’s why I’m here to learn and get real guidance from experienced developers.

6. What interests you the most about API Dash?

API Dash combines AI and APIs, and I like how it simplifies complex responses into clean, usable output. It’s also open source with strong developer support, making it a great place to learn and contribute.


7. Can you mention some areas where the project can be improved?

# A few things stood out after exploring the project

1. AI API responses are raw JSON with no clear separation between reasoning tool calls and final output which feels like the biggest gap

2. A sandbox mode to paste JSON and preview the UI would help a lot

3. The response history could be more visual with a timeline view for easier debugging

8. Have you interacted with and helped API Dash community? (GitHub/Discord links)

I haven’t actively contributed yet, but I’ve gone through the documentation, explored the codebase, and regularly attended the weekly meet discussions to understand the project and community better.

### Project Proposal Information

1. Proposal Title
Open Responses & Generative UI: From Raw JSON to Live UI

2. Abstract: A brief summary about the problem that you will be tackling & how.

Right now API Dash shows raw JSON for AI responses, making it hard to understand what actually happened. This project will convert those into clean visuals like reasoning timelines or interactive UI components, with one-click export to Flutter or React code. It uses Open Responses and A2UI standards, so it works across different AI providers.

3. Detailed Description

![A2UI_Flow](https://github.com/Syed-Abdullah-G/apidash/blob/20b7d6b06e7d8e6d7f41b92f0fdbb1c3b24daef2/doc/proposals/2026/gsoc/images/understanding-A2UI.png)


## The Problem in Plain English

Imagine you send a request to an AI API and it comes back with something like this:

{
  "type": "response",
  "output": [
    { "type": "reasoning", "content": "..." },
    {
      "type": "message",
      "content": [
        { "type": "card", "title": "Weather in Chennai" }
      ]
    }
  ]
}

That JSON is actually telling you "here’s my reasoning, and here’s a card UI to show the result."

But right now in API Dash, you just see raw text. You have to decode it in your head.  
My project makes API Dash decode it for you and show you what it actually means visually.

## How It Works The Flow

Here's the step by step journey of a response through the system I will build

Step 1  
The user sends an AI API request from API Dash using any provider like OpenAI Gemini or Anthropic  

Step 2  
The response comes back as JSON and the parser checks whether it is Open Responses format A2UI format or plain JSON  

Step 3  
If it is Open Responses it is converted into a structured timeline showing reasoning tool calls function outputs and final message  

Step 4  
If it is A2UI it is rendered as a live interactive UI component inside API Dash like buttons cards or tables  

Step 5  
The developer can switch between raw JSON view and visual view anytime  

Step 6  
Once satisfied they can click Export Code to get clean Flutter or React code ready to use

## The Five Pieces I Will Build

### Piece 1 The Parser  
This is the core engine that reads raw JSON from the AI API and understands what it contains like reasoning tool calls or UI components. It validates responses using Open Responses and converts them into clean internal structures while also supporting streaming data.

### Piece 2 The Format Detector  
This identifies the type of response whether it is Open Responses A2UI or plain JSON so each can be handled correctly with its own rendering logic.

### Piece 3 The Structured Timeline  
For Open Responses this creates a visual timeline instead of raw JSON with separate cards for reasoning tool calls and final output making everything easy to understand.

### Piece 4 The Widget Renderer  
For A2UI responses this renders real UI components like buttons cards or tables inside API Dash using a registry that maps JSON to Flutter widgets or React elements.

### Piece 5 The Code Exporter  
This lets developers export the rendered UI as clean Flutter or React code ready to copy paste into their own apps.


## Architecture Flow Diagram

![System_Architecture_Flow](https://github.com/Syed-Abdullah-G/apidash/blob/4a9cba934fc79eac6f97777e62dc4e211f20ba95/doc/proposals/2026/gsoc/images/system_architecture_updated_flow.svg)


4. Weekly Timeline: A week-wise timeline of activities that you would undertake.

## Project Timeline 12 Weeks / 90 Hours

| Week   | Focus                        | What I Will Do                                                                 | Deliverable                        |
|--------|------------------------------|------------------------------------------------------------------------------|------------------------------------|
| Week 1 | Setup and Research           | Understand Open Responses and A2UI and explore API Dash codebase             | Architecture plan and notes         |
| Week 2 | Parser Core                  | Build a parser to read AI JSON and handle streaming responses                | Working parser with tests           |
| Week 3 | Format Detection             | Detect response type and handle errors safely                                | Reliable detection system           |
| Week 4 | Timeline UI                  | Design timeline view with cards for each AI step                             | Basic timeline UI                   |
| Week 5 | Timeline Integration         | Connect real API responses to the timeline                                   | Fully working timeline              |
| Week 6 | Streaming Support            | Show responses updating live as data arrives                                 | Real time updates                   |
| Week 7 | A2UI Renderer Basics         | Map JSON to basic UI components like text button and card                    | Basic UI rendering                  |
| Week 8 | Advanced UI Components       | Add support for tables images and more components                            | Full UI rendering support           |
| Week 9 | Code Export                  | Let users export UI as Flutter or React code                                 | One click export feature            |
| Week 10| Simulate Mode and Split View | Add JSON sandbox and side by side view                                       | Preview and testing tools           |
| Week 11| Testing and Fixes            | Test everything and fix bugs                                                 | Stable working version              |
| Week 12| Docs and Final PR            | Write docs and submit final code                                             | Documentation and final submission  |

I planned 12 weeks instead of 10 so I have extra time for testing and documentation, making sure everything is stable and well polished.


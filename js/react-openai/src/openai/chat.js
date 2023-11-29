import { ChatOpenAI } from "langchain/chat_models/openai";
import { OpenAIChat } from "langchain/llms/openai";
import { PromptTemplate } from "langchain/prompts";
import { StringOutputParser } from "langchain/schema/output_parser";
import {
  RunnablePassthrough,
  RunnableSequence
} from "langchain/schema/runnable";
import { SupabaseVectorStore } from "langchain/vectorstores/supabase";
import { OpenAIEmbeddings } from "langchain/embeddings/openai";
import { createClient } from "@supabase/supabase-js";
import {
  SequentialChain,
  ConversationalRetrievalQAChain,
  LLMChain
} from "langchain/chains";
import { load } from "langchain/document_loaders/base";

// import config from "../../config.js";
const config = {
  azureOpenAIApiKey: "c63680b3ace94509a5271e873477d02a",
  azureOpenAIApiVersion: "2023-03-15-preview",
  azureOpenAIBasePath:
    "https://iap-instance-dev.openai.azure.com/openai/deployments",
  azureOpenAIApiDeploymentName: "chatgpt35",
  azureOpenAIApiEmbeddingsDeploymentName: "embeddingada002",
  azureOpenAIApiInstanceName: "iap-instance-dev",
  model: "gpt-35-turbo"
};

const model = new ChatOpenAI({
  modelName: config.model,
  azureOpenAIApiKey: config.azureOpenAIApiKey,
  azureOpenAIBasePath: config.azureOpenAIBasePath,
  azureOpenAIApiDeploymentName: config.azureOpenAIApiDeploymentName,
  azureOpenAIApiVersion: config.azureOpenAIApiVersion,
  azureOpenAIApiInstanceName: config.azureOpenAIApiDeploymentName,
  temperature: 0.9
});

const joke_promptTemplate = new PromptTemplate({
  template: `Tell me a joke about {topic}`,
  inputVariables: ["topic"]
});

// const chain = promptTemplate.pipe(model);

// const stream = await chain.stream({ topic: "bears" });

// for await (const chunk of stream) {
//   console.log(chunk?.content);
// }

const promptTemplate = new PromptTemplate({
  template: `You are a playwright. Given the title of play and the era it is set in, it is your job to write a synopsis for that title.
   Title: {title}
   Era: {era}
   Playwright: This is a synopsis for the above play:`,
  inputVariables: ["title", "era"]
});

const reviewPromptTemplate = new PromptTemplate({
  template: `You are a play critic from the New York Times. Given the synopsis of play, it is your job to write a review for that play.
  
       Play Synopsis:
       {synopsis}
       Review from a New York Times play critic of the above play:`,
  inputVariables: ["synopsis"]
});

// const overallChain = new SequentialChain({
//   chains: [
//     new LLMChain({
//       llm: model,
//       prompt: promptTemplate,
//       outputKey: "synopsis"
//     }),
//     new LLMChain({
//       llm: model,
//       prompt: reviewPromptTemplate,
//       outputKey: "review"
//     })
//   ],
//   inputVariables: ["era", "title"],
//   outputVariables: ["synopsis", "review"],
//   verbose: true
// });

// const chainExecutionResult = await overallChain.call({
//   title: "Tragedy at sunset on the beach",
//   era: "Victorian England"
// });
// console.log(chainExecutionResult);
const overallChain = new SequentialChain({
  chains: [
    new LLMChain({
      llm: model,
      prompt: joke_promptTemplate,
      outputKey: "answer"
    })
  ],
  inputVariables: ["topic"],
  outputVariables: ["answer"],
  verbose: true
});
// overallChain.callbacks();
overallChain.call({ topic: "List all Wiz bulbs" }).then((res) => {
  console.log(res);
});

// const model = new OpenAIChat({
//   modelName: config.model,
//   azureOpenAIApiKey: config.azureOpenAIApiKey,
//   azureOpenAIBasePath: config.azureOpenAIBasePath,
//   azureOpenAIApiDeploymentName: config.azureOpenAIApiDeploymentName,
//   azureOpenAIApiVersion: config.azureOpenAIApiVersion,
//   azureOpenAIApiInstanceName: config.azureOpenAIApiDeploymentName,
//   temperature: 0.9
// });
// const res = await model.call(
//   "What would be a good company name a company that makes colorful socks?"
// );
// console.log({ res });

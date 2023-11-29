import { SupabaseVectorStore } from "langchain/vectorstores/supabase";
import { OpenAIEmbeddings } from "langchain/embeddings/openai";
import { createClient } from "@supabase/supabase-js";
import config from "../config.js";

const openAIApiKey = config["OPENAI_API_KEY"];

const embeddings = new OpenAIEmbeddings({ openAIApiKey });
const sbApiKey = config["SUPABASE_API_KEY"];
const sbUrl = config["SUPABASE_URL_LC_CHATBOT"];
const client = createClient(sbUrl, sbApiKey);

const vectorStore = new SupabaseVectorStore(embeddings, {
  client,
  tableName: "documents",
  queryName: "match_documents"
});

const retriever = vectorStore.asRetriever();

export { retriever };
module Supple
  SETTINGS = {
    number_of_shards: 1,
    number_of_replicas: 0,
    analysis: {
      analyzer: {
        word_start_ngram: {
          type: "custom",
          tokenizer: "word_start_ngram_tokenizer",
          filter: ["lowercase", "asciifolding"]
        },
        words: {
          type: "custom",
          tokenizer: "keyword",
          filter: ["lowercase", "asciifolding"]
        }
      },
      tokenizer: {
        word_start_ngram_tokenizer: {
          type: "edgeNGram",
          min_gram: 1,
          max_gram: 50,
          token_chars: ["letter"]
        }
      }
    }
  }


end

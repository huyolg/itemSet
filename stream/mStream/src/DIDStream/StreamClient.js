import DID_API from './api.json';

const fetchStreamMsg = async () => {
  console.log('来了-----');
  //   return new Promise(async (resolve, reject) => {
  //     resolve(sessionResponse);
  //   });

  const sessionResponse = await fetchWithRetries(
    `${DID_API.url}/talks/streams`,
    {
      method: 'POST',
      headers: {
        Authorization: `Basic ${DID_API.key}`,
        'Content-Type': 'application/json',
      },
      body: JSON.stringify({
        source_url: 'https://d-id-public-bucket.s3.amazonaws.com/or-roman.jpg',
      }),
    },
  );
  return sessionResponse;
};

const maxRetryCount = 3;
const maxDelaySec = 4;

const fetchWithRetries = async (url, options, retries = 1) => {
  console.log('地址 = , url', url);
  try {
    return await fetch(url, options);
  } catch (err) {
    if (retries <= maxRetryCount) {
      const delay =
        Math.min(Math.pow(2, retries) / 4 + Math.random(), maxDelaySec) * 1000;

      await new Promise(resolve => setTimeout(resolve, delay));

      console.log(
        `Request failed, retrying ${retries}/${maxRetryCount}. Error ${err}`,
      );
      return fetchWithRetries(url, options, retries + 1);
    } else {
      throw new Error(`Max retries exceeded. error: ${err}`);
    }
  }
};

export default {
  fetchStreamMsg,
};

/*
 ZC1oLXlsZzAwMUB5b3BtYWlsLm5ldA:33o_TLliiY-mUm2Hv-jrR
ZC1oLXlsZzAwMkB5b3BtYWlsLm5ldA:H0wI1DZCIJBBXZDKKM85O

*/

import http from 'k6/http';
import { check, sleep } from 'k6';

export const options = {
  vus: 50,
  duration: '1m',
  thresholds: {
    http_req_failed: ['rate<0.01'],
    http_req_duration: ['p(95)<2000']
  }
};

export default function () {
  let res = http.get('http://localhost:3001/products/1/related');
  check(res,
    {'get product is status 200': (r) => r.status === 200
  'text verification': (r) => r.body.includes('Forest Green & Black')
    }
  )
}
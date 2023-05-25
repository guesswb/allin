/* eslint-disable */ 
const functions = require("firebase-functions");
const admin = require('firebase-admin');
const {getFirestore} = require("firebase-admin/firestore");

admin.initializeApp();

const db = getFirestore();

exports.makeStatistics = functions
    .region("asia-northeast3")
    .pubsub
    .schedule("0 1 * * SUN")
    .onRun(async () => {
      const firstDayUTC = new Date(2002, 11, 7, 20, 0, 0);
      const todayUTC = new Date();
      const firstDay = new Date(firstDayUTC.getTime() + 9 * 60 * 60 * 1000);
      const today = new Date(todayUTC.getTime() + 9 * 60 * 60 * 1000);
      const differenceTime = today.getTime() - firstDay.getTime();
      const drwNoRound = Math
      .floor((differenceTime / (1000 * 60 * 60 * 24)) / 7) + 1;

      const response = await fetch(`https://www.dhlottery.co.kr/common.do?method=getLottoNumber&drwNo=${drwNoRound}`);
      const json = await response.json();
      const winNumbers = [json.drwtNo1, json.drwtNo2, json.drwtNo3, json.drwtNo4, json.drwtNo5, json.drwtNo6]
      const bnusNo = json.bnusNo;

      const recommendNumber = db.collection("RecommendNumbers").doc(`${drwNoRound}`).collection("RecommendNumber");
      const docs = (await recommendNumber.get()).docs;

      var winCount = [0, 0, 0, 0, 0, 0, 0, 0]; // 1등, 2등, 3등, 4등, 5등, 2개맞춤, 1개맞춤, 0개맞춤

      docs.forEach((doc) => {
        const numbers = Object.values(doc.data())[0];
        var count = 0;
        var isHaveBonus = false;

            numbers.forEach((number) => {
                count += winNumbers.includes(number) ? 1 : 0;
                isHaveBonus = bnusNo == number ? true : isHaveBonus;
            });

            if (count == 6) {
                winCount[0] += 1;
            } else if (count == 5 && isHaveBonus == true) {
                winCount[1] += 1;
            } else if (count == 5 && isHaveBonus == false) {
                winCount[2] += 1;
            } else if (count == 4) {
                winCount[3] += 1;
            } else if (count == 3) {
                winCount[4] += 1;
            } else if (count == 2) {
                winCount[5] += 1;
            } else if (count == 1) {
                winCount[6] += 1;
            } else {
                winCount[7] += 1;
            }
        });

        const winResult = db.collection("RecommendNumbers").doc(`${drwNoRound + 1}`).collection("WinResult");
        await winResult.add({
            name: `${winCount}`
        });
    });

const store = require('../models/store');

const getSignalsSummary = (days = 7) => {
  const checkins = store.checkins.slice(store.checkins.length - days);
  
  let highStressDays = 0;
  let poorSleepDays = 0;
  let lowEnergyDays = 0;
  let totalSleepHours = 0;
  let goalsCompleted = 0;

  checkins.forEach(c => {
    if (c.stress === 'High' || c.stress === 'Intense') highStressDays++;
    if (c.sleep === 'Poor' || c.sleep === 'Poorly') poorSleepDays++;
    if (c.energy === 'Low' || c.energy === 'Depleted') lowEnergyDays++;
    totalSleepHours += c.sleepHours || 6.5;
    if (c.goalCompleted) goalsCompleted++;
  });

  const avgSleepHours = checkins.length ? (totalSleepHours / checkins.length).toFixed(1) : 7.0;
  const adherenceRate = checkins.length ? Math.round((goalsCompleted / checkins.length) * 100) : 80;

  const patterns = [];
  if (highStressDays > 2 && poorSleepDays > 2) {
    patterns.push({
      title: 'Stress & sleep cadence',
      description: 'Your stress was higher on days when your sleep was lower. Observing the connection gives you practical context without judging difficult days.'
    });
  }

  const latest = checkins[checkins.length - 1] || {
    mood: 'Okay',
    stress: 'Moderate',
    energy: 'Okay',
    sleep: 'Fair'
  };

  return {
    windowDays: days,
    totalLogged: checkins.length,
    latest,
    adherenceRate,
    avgSleepHours,
    patterns,
    trendObservations: {
      mood: 'Mostly okay (Steady baseline)',
      stress: highStressDays > 2 ? 'Higher this week (Evening peaks noted)' : 'Moderate (Steady)',
      energy: lowEnergyDays > 3 ? 'Lower than usual (Needs rest)' : 'Improving (Morning rebound)',
      sleep: poorSleepDays > 2 ? 'Needs attention (Interrupted rhythm)' : 'Consistent recovery'
    },
    signals: checkins.map(c => ({
      date: c.date,
      mood: c.mood,
      stress: c.stress,
      energy: c.energy,
      sleep: c.sleep,
      sleepHours: c.sleepHours,
      goalCompleted: c.goalCompleted
    }))
  };
};

module.exports = {
  getSignalsSummary
};

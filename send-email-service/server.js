const express = require('express');
const bodyParser = require('body-parser');
const sendEmail = require('./sendEmail'); 

const app = express();
app.use(bodyParser.json());

app.post('/send-booking-email', async (req, res) => {
  try {
    const {
      recipient,
      bookingDateTime,
      serviceType,
      services,
      serviceTime,
      subtotal,
      gst,
      totalAmount,
      clothingPrice,
      turfCharge,
      membership,
      clothingType,
    } = req.body;

    await sendEmail({
      recipient,
      bookingDateTime,
      serviceType,
      services,
      serviceTime,
      subtotal,
      gst,
      totalAmount,
      clothingPrice,
      turfCharge,
      membership,
      clothingType,
    });

    res.status(200).send({ success: true, message: 'Email sent successfully!' });
  } catch (error) {
    console.error('Error in /send-booking-email:', error);
    res.status(500).send({ success: false, message: 'Failed to send email.' });
  }
});

app.listen(3000, () => {
  console.log('Server running on http://localhost:3000');
});

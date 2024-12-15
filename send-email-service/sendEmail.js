const nodemailer = require('nodemailer');

const transporter = nodemailer.createTransport({
  service: 'gmail',
  port:465,  
  auth: {
    user: 'homesdoodle@gmail.com', 
    pass: 'pftb fezm rbqo vqbe',   
  },
  tls:{
    rejectUnauthorized:'true'
  }
});

const sendEmail = async ({
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
}) => {
  let emailContent = `
    <div style="font-family: Arial, sans-serif; max-width: 600px; margin: 20px auto; padding: 20px; border: 1px solid #ddd; border-radius: 8px;">
      <h2 style="text-align: center; color: #333;">Doodle Homes Booking Confirmation</h2>
      <hr style="border: 0; border-top: 1px solid #eee;">
      <p style="font-size: 16px; color: #555;">
        Thank you for choosing Doodle Homes. Below are the details of your booking:
      </p>
      <h3 style="color: #444;">Booking Details</h3>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Booking Date and Time:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd;">${bookingDateTime}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Service Type:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd;">${serviceType}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Service Time:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd;">${serviceTime}</td>
        </tr>
      </table>
      <h3 style="color: #444;">Selected Services</h3>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <thead>
          <tr style="background-color: #f9f9f9;">
            <th style="padding: 10px; border: 1px solid #ddd; text-align: left;">Service</th>
            <th style="padding: 10px; border: 1px solid #ddd; text-align: right;">Price</th>
          </tr>
        </thead>
        <tbody>`;

  services.forEach(service => {
    emailContent += `
          <tr>
            <td style="padding: 10px; border: 1px solid #ddd;">${service.name}</td>
            <td style="padding: 10px; border: 1px solid #ddd; text-align: right;">${service.price}</td>
          </tr>`;
  });

  emailContent += `
        </tbody>
      </table>
      <h3 style="color: #444;">Billing Details</h3>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Subtotal:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd; text-align: right;">${subtotal}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>GST:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd; text-align: right;">${gst}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Total Amount:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd; text-align: right;">${totalAmount}</td>
        </tr>
      </table>`;

  if (serviceType === 'Laundry') {
    emailContent += `
      <h3 style="color: #444;">Laundry Details</h3>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Clothing Price:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd; text-align: right;">${clothingPrice}</td>
        </tr>
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Clothing Type:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd;">${clothingType}</td>
        </tr>
      </table>`;
  }

  if (serviceType === 'Turf & Club') {
    emailContent += `
      <h3 style="color: #444;">Turf & Club Details</h3>
      <table style="width: 100%; border-collapse: collapse; margin-bottom: 20px;">
        <tr>
          <td style="padding: 10px; border: 1px solid #ddd; background-color: #f9f9f9;"><strong>Turf Charge:</strong></td>
          <td style="padding: 10px; border: 1px solid #ddd; text-align: right;">${turfCharge}</td>
        </tr>
      </table>`;
  }

  if (membership) {
    emailContent += `
      <h3 style="color: #444;">Membership</h3>
      <p style="font-size: 16px; color: #555;">You are enrolled in our <strong>${membership}</strong> membership.</p>`;
  }

  emailContent += `
      <hr style="border: 0; border-top: 1px solid #eee;">
      <p style="font-size: 14px; color: #777; text-align: center;">
        If you have any questions, feel free to contact us at support@doodlehomes.com.
      </p>
    </div>`;

  const mailOptions = {
    from: 'homesdoodle@gmail.com', 
    to: recipient,               
    cc: 'varad11220@gmail.com', 
    subject: 'Your Booking Details',
    html: emailContent,           
  };
  

  try {
    const info = await transporter.sendMail(mailOptions);
    console.log('Email sent: ' + info.response);
  } catch (error) {
    console.error('Error sending email: ' + error);
  }
};

module.exports = sendEmail;

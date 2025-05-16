document.addEventListener('DOMContentLoaded', function() {
    const profileForm = document.querySelector('.profile-form');
    const passwordForm = document.querySelector('.password-form');

    // Profile form submission
    if (profileForm) {
        profileForm.addEventListener('submit', async function(e) {
            e.preventDefault();
            
            try {
                const formData = new FormData(profileForm);
                const response = await fetch(profileForm.action, {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    showMessage('Profile updated successfully!', 'success');
                } else {
                    const error = await response.text();
                    showMessage(error || 'Failed to update profile', 'error');
                }
            } catch (error) {
                showMessage('An error occurred. Please try again.', 'error');
            }
        });
    }

    // Password form submission
    if (passwordForm) {
        passwordForm.addEventListener('submit', async function(e) {
            e.preventDefault();

            const newPassword = passwordForm.querySelector('#newPassword').value;
            const confirmPassword = passwordForm.querySelector('#confirmPassword').value;

            if (newPassword !== confirmPassword) {
                showMessage('Passwords do not match', 'error');
                return;
            }

            try {
                const formData = new FormData(passwordForm);
                const response = await fetch(passwordForm.action, {
                    method: 'POST',
                    body: formData
                });

                if (response.ok) {
                    showMessage('Password updated successfully!', 'success');
                    passwordForm.reset();
                } else {
                    const error = await response.text();
                    showMessage(error || 'Failed to update password', 'error');
                }
            } catch (error) {
                showMessage('An error occurred. Please try again.', 'error');
            }
        });
    }

    // Show message function
    function showMessage(message, type) {
        const messageDiv = document.createElement('div');
        messageDiv.className = `message ${type}-message`;
        messageDiv.innerHTML = `
            <i class="fas ${type === 'success' ? 'fa-check-circle' : 'fa-exclamation-circle'}"></i>
            <span>${message}</span>
        `;

        const container = document.querySelector('.profile-container');
        container.insertBefore(messageDiv, container.firstChild);

        setTimeout(() => {
            messageDiv.remove();
        }, 5000);
    }
}); 
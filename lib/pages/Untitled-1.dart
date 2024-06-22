
  Widget _buildForMobile(Size size) {
    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      child: Center(
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: size.width * 0.06),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(height: size.height * 0.06),
              Image.asset(
                'assets/logo/collab_logo.png',
                width: size.width * 0.4,
                height: 200,
              ),
              SizedBox(height: size.height * 0.002),
              const Text(
                'Verify Account',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              Text(
                'Code has been sent to ${widget.phoneNumber}.\nEnter code to verify your account',
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w400,
                  color: Colors.black,
                ),
                textAlign: TextAlign.center,
              ),
              SizedBox(height: size.height * 0.03),
              const FieldText(text: 'Enter Code'),
              SizedBox(height: size.height * 0.004),
              TextField(
                controller: codeController,
                decoration: InputDecoration(
                  hintText: '6 Digits Code',
                  hintStyle: TextStyle(color: Colors.grey[400]),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.2),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text(
                    'Didn\'t receive code?  ',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kBlack,
                    ),
                  ),
                  GestureDetector(
                    onTap: _resendCode,
                    child: const Text(
                      'Resend Code',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        color: KAppColors.kAccent,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
              const Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'Resend code in 00:59',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: KAppColors.kBlack,
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.03),
              ButtonWidget(
                size: size,
                color: KAppColors.kPrimary,
                onTap: _verifyCode,
                text: 'Verify Account',
              ),
              SizedBox(height: size.height * 0.07),
            ],
          ),
        ),
      ),
    );
  }

import 'package:flutter_implementation_task/common_libs.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final AuthLogic _authLogic = GetIt.I.get<AuthLogic>();
  bool _obscurePassword = true;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleLogin() async {
    if (_formKey.currentState!.validate()) {
      final success = await _authLogic.login(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      if (mounted) {
        if (success) {
          // Navigate to home
          context.goToHome();
        } else {
          // Show error
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(_authLogic.errorMessage ?? 'Login failed'),
              backgroundColor: $styles.colors.error,
            ),
          );
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: $styles.colors.white,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: ListenableBuilder(
          listenable: _authLogic,
          builder: (context, _) {
            return SingleChildScrollView(
              padding: EdgeInsets.all($styles.insets.lg),
              child: Form(
                key: _formKey,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    SizedBox(height: $styles.insets.xl),
                    
                    // Logo
                    Center(
                      child: Container(
                        width: 80,
                        height: 80,
                        decoration: BoxDecoration(
                          color: $styles.colors.primary,
                          borderRadius: BorderRadius.circular($styles.corners.lg),
                        ),
                        child: Icon(
                          Icons.flutter_dash,
                          size: 50,
                          color: $styles.colors.white,
                        ),
                      ),
                    ),
                    
                    SizedBox(height: $styles.insets.xl),
                    
                    // Title
                    Text(
                      'Welcome Back',
                      style: $styles.text.title2,
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: $styles.insets.sm),
                    Text(
                      'Sign in to continue',
                      style: $styles.text.body.copyWith(
                        color: $styles.colors.white,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    
                    SizedBox(height: $styles.insets.xxl),
                    
                    // Email field
                    TextFormField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        hintText: 'Enter your email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular($styles.corners.md),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your email';
                        }
                        if (!value.contains('@')) {
                          return 'Please enter a valid email';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: $styles.insets.lg),
                    
                    // Password field
                    TextFormField(
                      controller: _passwordController,
                      obscureText: _obscurePassword,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        hintText: 'Enter your password',
                        prefixIcon: const Icon(Icons.lock_outlined),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _obscurePassword
                                ? Icons.visibility_outlined
                                : Icons.visibility_off_outlined,
                          ),
                          onPressed: () {
                            setState(() => _obscurePassword = !_obscurePassword);
                          },
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular($styles.corners.md),
                        ),
                      ),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }
                        if (value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                    ),
                    
                    SizedBox(height: $styles.insets.md),
                    
                    // Forgot password
                    Align(
                      alignment: Alignment.centerRight,
                      child: TextButton(
                        onPressed: () {
                          // Handle forgot password
                        },
                        child: Text(
                          'Forgot Password?',
                          style: $styles.text.bodySmall.copyWith(
                            color: $styles.colors.primary,
                          ),
                        ),
                      ),
                    ),
                    
                    SizedBox(height: $styles.insets.lg),
                    
                    // Login button
                    ElevatedButton(
                      onPressed: _authLogic.isLoading ? null : _handleLogin,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: $styles.colors.primary,
                        foregroundColor: $styles.colors.white,
                        padding: EdgeInsets.symmetric(vertical: $styles.insets.md),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular($styles.corners.md),
                        ),
                      ),
                      child: _authLogic.isLoading
                          ? SizedBox(
                              height: 20,
                              width: 20,
                              child: CircularProgressIndicator(
                                strokeWidth: 2,
                                valueColor: AlwaysStoppedAnimation<Color>(
                                  $styles.colors.white,
                                ),
                              ),
                            )
                          : Text('Login', style: $styles.text.button),
                    ),
                    
                    SizedBox(height: $styles.insets.xl),
                    
                    // Sign up link
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          "Don't have an account? ",
                          style: $styles.text.body,
                        ),
                        TextButton(
                          onPressed: () => context.goToSignup(),
                          child: Text(
                            'Sign Up',
                            style: $styles.text.bodyBold.copyWith(
                              color: $styles.colors.primary,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
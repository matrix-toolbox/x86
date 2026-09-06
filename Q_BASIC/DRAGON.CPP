// 20030611
//
// BC++BUILDER

T_dragon* _dragon;

short* get_array(short * _array, int M_ITERATIONS) {
    auto int i, j, k;
    for (i = 0; i < 2 << M_ITERATIONS - 1; _array[i++] = 0);
    for (k = 1; k < M_ITERATIONS; k++) {
        i = 1;
        for (j = 2 << k - 1; j < (2 << k) - 1;)
            _array[j] = (_array[j++ - 2 * i++] + 1) % 2;
    }
    return _array;
}

void draw_dragon(short * _array, int M_ITERATIONS) {
    short delta_x = 0;
    short delta_y = 1;
    int i;
    int x = StrToInt(_dragon->_x_pos->Text);
    int y = StrToInt(_dragon->_y_pos->Text);
    int A = StrToInt(_dragon->_angle->Text);
    if (A > 3 || A < 0) {
        _dragon->_angle->Text = 1;
        A = 1;
    }
    int L = StrToInt(_dragon->_interval_length->Text);
    if (L > 100 || A < 0) {
        _dragon->_interval_length->Text = 100;
        L = 100;
    }
   _dragon->Canvas->MoveTo(x, y);
    for (i = 0; i < (2 << M_ITERATIONS - 1) - 1;) {
       _dragon->Canvas->LineTo(x += L * delta_x, y += L * delta_y);
       _array[i++] ? A++: A--;
        if (!(A - 4)) A = 0;
        if (!(A + 1)) A = 3;
        switch (A) {
            case 0:
                delta_x = +1;
                delta_y = +0;
                break;
            case 1:
                delta_x = +0;
                delta_y = +1;
                break;
            case 2:
                delta_x = -1;
                delta_y = +0;
                break;
            case 3:
                delta_x = +0;
                delta_y = -1;
                break;
        }
    }
}

void __RUN() {
    const int M_ITERATIONS = 16;
    int M_LENGTH = 2 << M_ITERATIONS - 1;
    short* _array = (short*) malloc(M_LENGTH * sizeof(short));
    draw_dragon(get_array(_array, M_ITERATIONS), M_ITERATIONS);
    free(_array);
}

void __fastcall T_dragon::FormClick(TObject *Sender) {
    __RUN();
}


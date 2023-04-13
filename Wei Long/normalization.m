function I1=normalization(I)
Min=min(min(I));
Max=max(max(I));
I1=(I-Min)*255/(Max-Min);
I1=uint8(I1);
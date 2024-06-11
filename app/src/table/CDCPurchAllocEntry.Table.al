table 6085732 "CDC Purch. Alloc. Entry"
{
    Caption = 'Purch. Alloc. Entry';

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
        }
        field(2; "Document No."; Code[20])
        {
            Caption = 'Document No.';
        }
        field(4; "Posting Date"; Date)
        {
            Caption = 'Posting Date';
        }
        field(5; "Source Type"; Option)
        {
            Caption = 'Source Type';
            OptionCaption = 'Quote,Order,Invoice,Credit Memo,Blanket Order,Return Order';
            OptionMembers = Quote,"Order",Invoice,"Credit Memo","Blanket Order","Return Order";
        }
        field(6; "Source No."; Code[20])
        {
            Caption = 'Source No.';
            TableRelation = "Purchase Header"."No." where("Document Type" = field("Source Type"));
        }
        field(13; "Vendor Invoice No."; Code[35])
        {
            Caption = 'Vendor Invoice No.';
        }
        field(14; "Vendor Cr. Memo No."; Code[35])
        {
            Caption = 'Vendor Cr. Memo No.';
        }
        field(15; "Vendor No."; Code[20])
        {
            Caption = 'Vendor No.';
            TableRelation = Vendor;
        }
        field(16; "Vendor Posting Group"; Code[20])
        {
            Caption = 'Vendor Posting Group';
            TableRelation = "Vendor Posting Group";
        }
        field(19; Amount; Decimal)
        {
            Caption = 'Amount';
        }
        field(20; "Amount (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount (LCY)';
        }
        field(22; "Amount Including VAT"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT';
            Editable = false;
        }
        field(23; "Amount Including VAT (LCY)"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Amount Including VAT (LCY)';
            Editable = false;
        }
        field(24; "Dimension Set ID"; Integer)
        {
            Caption = 'Dimension Set ID';
            TableRelation = "Dimension Set Entry";
        }
        field(30; Open; Boolean)
        {
            Caption = 'Open';
        }
        field(31; "Applies-to Entry"; Integer)
        {
            Caption = 'Applies-to Entry';
            Editable = false;
        }
        field(40; "Shortcut Dimension 1 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 1 Code';
            CaptionClass = '1,2,1';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(1));
        }
        field(41; "Shortcut Dimension 2 Code"; Code[20])
        {
            Caption = 'Shortcut Dimension 2 Code';
            CaptionClass = '1,2,2';
            Editable = false;
            TableRelation = "Dimension Value".Code where("Global Dimension No." = const(2));
        }
        field(42; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; "Document No.", "Posting Date")
        {
        }
        key(Key3; "Vendor No.", "Posting Date", "Currency Code")
        {
        }
        key(Key4; "Vendor No.", Open, "Currency Code", "Shortcut Dimension 1 Code", "Shortcut Dimension 2 Code", "Posting Date")
        {
            SumIndexFields = "Amount (LCY)", "Amount Including VAT (LCY)";
        }
        key(Key5; "Source Type", "Source No.")
        {
            SumIndexFields = Amount, "Amount Including VAT";
        }
    }

    procedure ShowDimensions()
    begin
    end;
}
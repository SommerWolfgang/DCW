table 6086331 "CEM Bank Transaction Inbox"
{
    Caption = 'Bank Transactions Inbox';
    DataCaptionFields = "Entry No.", "Card No.", "Card Name";

    fields
    {
        field(1; "Entry No."; Integer)
        {
            Caption = 'Entry No.';
            Editable = false;
        }
        field(2; "Card No."; Code[20])
        {
            Caption = 'Card No.';
            TableRelation = "CEM Continia User Credit Card"."Card No.";
            //This property is currently not supported
            //TestTableRelation = false;
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
                EMSetup: Record "CEM Expense Management Setup";
            begin
                EMSetup.Get;
                if not EMSetup."Use CC Mapping for dup. Cards" then begin
                    UserCreditCard.SetCurrentKey("Card No.");
                    UserCreditCard.SetRange("Card No.", "Card No.");
                    if not UserCreditCard.IsEmpty then
                        if UserCreditCard.Count = 1 then
                            Validate("Continia User ID", UserCreditCard."Continia User ID")
                end;
            end;
        }
        field(3; "Card Name"; Text[50])
        {
            Caption = 'Card Name';
            Editable = false;
        }
        field(5; "Posting Date"; Date)
        {
            Caption = 'Posting Date';

            trigger OnValidate()
            begin
                if "Posting Date" = xRec."Posting Date" then
                    exit;

                if "Original Posting Date" = 0D then begin
                    if ValidPostingDate(xRec."Posting Date") then
                        Error(PostingDateOKErr, xRec."Posting Date");
                    "Original Posting Date" := xRec."Posting Date";
                end;

                PostingDateAllowedCheck;
            end;
        }
        field(6; "Document Date"; Date)
        {
            Caption = 'Document Date';
            Editable = false;
        }
        field(7; "Currency Code"; Code[10])
        {
            Caption = 'Currency Code';
            Editable = false;
            //The property 'ValidateTableRelation' can only be set if the property 'TableRelation' is set
            //ValidateTableRelation = false;
        }
        field(8; "Currency Exch. Rate"; Decimal)
        {
            Caption = 'Currency Exchange Rate';
            DecimalPlaces = 0 : 15;
            Editable = false;
        }
        field(9; Amount; Decimal)
        {
            AutoFormatExpression = "Currency Code";
            AutoFormatType = 1;
            Caption = 'Amount';
            Editable = false;
        }
        field(10; "Bank-Currency Amount"; Decimal)
        {
            AutoFormatType = 1;
            Caption = 'Bank-Currency Amount';
            Editable = false;
        }
        field(11; "Entry Type"; Integer)
        {
            Caption = 'Entry Type';
            Editable = false;
        }
        field(12; "Business Category ID"; Code[50])
        {
            Caption = 'Business Category ID';
            Editable = false;
        }
        field(13; "Business No."; Code[20])
        {
            Caption = 'Business No.';
            Editable = false;
        }
        field(14; "Business Name"; Text[250])
        {
            Caption = 'Business Name';
            Editable = false;
        }
        field(15; "Business Address"; Text[80])
        {
            Caption = 'Business Address';
            Editable = false;
        }
        field(16; "Business Address 2"; Text[80])
        {
            Caption = 'Business Address 2';
            Editable = false;
        }
        field(17; "Business Address 3"; Text[80])
        {
            Caption = 'Business Address 3';
            Editable = false;
        }
        field(18; "Business Country/Region"; Code[20])
        {
            Caption = 'Business Country/Region';
            Editable = false;
        }
        field(19; "Business Post Code"; Code[20])
        {
            Caption = 'Business Post Code';
            Editable = false;
        }
        field(20; "Document Time"; Time)
        {
            Caption = 'Document Time';
            Editable = false;
        }
        field(22; "Transaction ID"; Text[150])
        {
            Caption = 'Transaction ID';
            Editable = false;
        }
        field(23; "Travel Passenger Name"; Text[50])
        {
            Caption = 'Travel Passenger Name';
            Editable = false;
        }
        field(24; "Travel Route"; Text[50])
        {
            Caption = 'Travel Route';
            Editable = false;
        }
        field(25; "Travel Departure Date"; Date)
        {
            Caption = 'Travel Departure Date';
            Editable = false;
        }
        field(26; "Travel Return Date"; Date)
        {
            Caption = 'Travel Return Date';
            Editable = false;
        }
        field(27; "Travel Ticket Number"; Text[50])
        {
            Caption = 'Travel Ticket Number';
            Editable = false;
        }
        field(40; "Bank Code"; Code[10])
        {
            Caption = 'Bank Code';
            Editable = false;
            TableRelation = "CEM Bank";
        }
        field(41; "Bank Country/Region"; Code[10])
        {
            Caption = 'Bank Country/Region';
            Editable = false;
            TableRelation = "CEM Bank Agreement"."Country/Region Code" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(45; "CO Entry No."; Integer)
        {
            Caption = 'Continia Online Entry No.';
        }
        field(50; "Continia User ID"; Code[50])
        {
            Caption = 'Continia User ID';
            TableRelation = "CDC Continia User Setup";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                UserCreditCard: Record "CEM Continia User Credit Card";
                EMSetup: Record "CEM Expense Management Setup";
            begin
                if "Continia User ID" = '' then
                    exit;
                EMSetup.Get;
                if not EMSetup."Use CC Mapping for dup. Cards" then begin
                    UserCreditCard.SetCurrentKey("Card No.");
                    UserCreditCard.SetRange("Card No.", "Card No.");
                    UserCreditCard.SetRange("Continia User ID", "Continia User ID");
                    UserCreditCard.FindFirst;
                end;
            end;
        }
        field(51; "Exclude Entry"; Boolean)
        {
            Caption = 'Exclude Entry';

            trigger OnValidate()
            begin
                if "Exclude Entry" then
                    "Error Text" := Text002
                else
                    "Error Text" := '';
            end;
        }
        field(60; "Transaction Type"; Option)
        {
            Caption = 'Transaction Type';
            Editable = false;
            OptionCaption = 'Normal,Balancing';
            OptionMembers = Normal,Balancing;
        }
        field(74; "Bank Statement Transaction"; Boolean)
        {
            Caption = 'Bank Statement Transaction';
            Editable = false;
        }
        field(92; "Try Processed Date/Time"; DateTime)
        {
            Caption = 'Try Processed Date Time';
            Editable = false;
        }
        field(94; "Imported Date/Time"; DateTime)
        {
            Caption = 'Imported Date Time';
            Editable = false;
        }
        field(95; "Imported by User ID"; Code[50])
        {
            Caption = 'Imported by';
            Editable = false;
        }
        field(96; "Processed Date/Time"; DateTime)
        {
            Caption = 'Processed Date Time';
            Editable = false;
        }
        field(97; "Processed by User ID"; Code[50])
        {
            Caption = 'Processed by';
            Editable = false;
        }
        field(98; "Error Text"; Text[250])
        {
            Caption = 'Error Text';
            Editable = false;
        }
        field(99; Status; Option)
        {
            Caption = 'Status';
            Editable = false;
            OptionCaption = 'Pending,Error,Accepted';
            OptionMembers = Pending,Error,Accepted;
        }
        field(100; "Agreement ID"; Text[30])
        {
            Caption = 'Agreement ID';
            Editable = false;
            TableRelation = "CEM Bank Agreement"."Agreement ID" WHERE("Bank Code" = FIELD("Bank Code"));
        }
        field(120; "Employee No."; Text[50])
        {
            Caption = 'Employee No.';
            Editable = false;
        }
        field(180; "Expense Type"; Code[20])
        {
            Caption = 'Expense Type';
            TableRelation = "CEM Expense Type";
            ValidateTableRelation = false;

            trigger OnValidate()
            var
                ExpenseType: Record "CEM Expense Type";
            begin
                ExpenseType.Get("Expense Type");
                Validate("Exclude Entry", ExpenseType."Exclude Transactions");
            end;
        }
        field(250; Duplicate; Boolean)
        {
            Caption = 'Duplicate';
        }
        field(260; "User Paid Credit Card"; Boolean)
        {
            Caption = 'Private Invoiced';
            Editable = false;
        }
        field(261; "Original Posting Date"; Date)
        {
            Caption = 'Original Posting Date';
            Editable = false;
        }
    }

    keys
    {
        key(Key1; "Entry No.")
        {
            Clustered = true;
        }
        key(Key2; Status, "Try Processed Date/Time")
        {
        }
        key(Key3; "Bank Code", "Bank Country/Region", Status)
        {
        }
        key(Key4; "Card No.", Status, "Posting Date")
        {
        }
        key(Key5; "Transaction ID")
        {
        }
    }

    fieldgroups
    {
    }

    trigger OnInsert()
    var
        BankTransactionInbox: Record "CEM Bank Transaction Inbox";
    begin
        if BankTransactionInbox.FindLast then
            Rec."Entry No." := BankTransactionInbox."Entry No." + 1
        else
            Rec."Entry No." := 1;

        Duplicate := IsDuplicate;
    end;

    trigger OnModify()
    begin
        if xRec.Status = xRec.Status::Accepted then
            TestField(Status, Status::Error);

        if Status = Status::Error then begin
            Status := Status::Pending;
            "Try Processed Date/Time" := 0DT;
            "Error Text" := '';
        end;
    end;

    trigger OnRename()
    begin
        Error(Text001, TableCaption);
    end;

    var
        BankFileFilters: Label 'All Files (*.*)|*.*';
        CreditCardPostingAccTxt: Label 'Use default posting account (%1 %2),Manually set up posting account';
        NoCreditCardMapping: Label '%1 must exist when %2 is set.';
        NotValidStatus: Label 'is not valid';
        PostingDateNotAllowedErr: Label 'Posting Date (%1) is not within your range of allowed posting dates. Please check the posting periods or change the Posting Date.';
        PostingDateOKErr: Label 'Posting Date (%1) is within your range of allowed posting dates and cannot be changed.';
        SelectBankTxt: Label 'Select Bank File';
        SetupPostingAccNowTxt: Label 'Do you want to set up the posting account now?';
        Text001: Label 'You cannot rename a %1.';
        Text002: Label 'This transaction will not be handled as it is excluded.';
        UserPaidCreditCardQst: Label 'Is this card privately invoiced?';
        UserPaidCreditCardTxt: Label 'The user will be refunded for expenses when using this credit card.';


    procedure MatchCard()
    var
        ContiniaUserSetup: Record "CDC Continia User Setup";
        InboxTransaction: Record "CEM Bank Transaction Inbox";
        UserCreditCard: Record "CEM Continia User Credit Card";
        CreditCardMapping: Record "CEM Credit Card Mapping";
        CreditCardUserMapping: Record "CEM Credit Card User Mapping";
        EMSetup: Record "CEM Expense Management Setup";
        BankTransactionInboxCheck: Codeunit "CEM Trans. Inbox-Transfer";
        RecRef: RecordRef;
        FieldRef: FieldRef;
        UserCreditCardBankConfigured: Boolean;
        UserCreditCardExists: Boolean;
        ContiniaUserID: Code[50];
        MappingFieldCount: Integer;
        PostingAccountAction: Option DoNothing,UseDefault,SetupManually;
    begin
        TestField("Continia User ID", '');
        TestField("Card No.");
        if PAGE.RunModal(0, ContiniaUserSetup) = ACTION::LookupOK then begin
            EMSetup.Get;
            if UserCreditCard.Get(ContiniaUserSetup."Continia User ID", "Card No.") then begin
                UserCreditCardExists := true;
                if UserCreditCard."Account No." <> '' then
                    UserCreditCardBankConfigured := true;
            end;

            if not UserCreditCardBankConfigured then
                if not "User Paid Credit Card" then begin
                    if EMSetup."Card Transaction Bal. No." <> '' then begin
                        PostingAccountAction :=
                          StrMenu(
                            StrSubstNo(CreditCardPostingAccTxt, EMSetup."Card Transaction Bal. Type", EMSetup."Card Transaction Bal. No."), 1);
                        if PostingAccountAction = PostingAccountAction::DoNothing then
                            Error('');
                    end else
                        if Confirm(SetupPostingAccNowTxt, true) then
                            PostingAccountAction := PostingAccountAction::SetupManually;
                end;

            if not UserCreditCardExists then begin
                UserCreditCard.Init;
                UserCreditCard."Continia User ID" := ContiniaUserSetup."Continia User ID";
                UserCreditCard."Card No." := "Card No.";
                if PostingAccountAction = PostingAccountAction::UseDefault then begin
                    UserCreditCard."Account Type" := EMSetup."Card Transaction Bal. Type";
                    UserCreditCard."Account No." := EMSetup."Card Transaction Bal. No.";
                    UserCreditCard."User Paid Credit Card" := EMSetup."User Paid Credit Card";
                end;
                UserCreditCard.Insert(true);
            end;

            if EMSetup."Ask User Paid Credit Card" and (not UserCreditCardBankConfigured) then
                if Confirm(UserPaidCreditCardQst + '\\' + UserPaidCreditCardTxt, false) then begin
                    UserCreditCard."User Paid Credit Card" := true;
                    UserCreditCard.Modify;
                end else begin
                    UserCreditCard."User Paid Credit Card" := false;
                    UserCreditCard.Modify;
                end;

            if EMSetup."Use CC Mapping for dup. Cards" then begin
                RecRef.GetTable(Rec);
                CreditCardUserMapping.SetRange("Card No.", "Card No.");
                CreditCardUserMapping.SetRange("Continia User ID", UserCreditCard."Continia User ID");
                CreditCardUserMapping.DeleteAll;
                if CreditCardMapping.FindSet then
                    repeat
                        CreditCardUserMapping.Validate("Continia User ID", UserCreditCard."Continia User ID");
                        CreditCardUserMapping.Validate("Card No.", "Card No.");
                        CreditCardUserMapping."Field No." := CreditCardMapping."Field No.";
                        FieldRef := RecRef.Field(CreditCardMapping."Field No.");
                        CreditCardUserMapping.Value := Format(FieldRef.Value);
                        CreditCardUserMapping.Insert(true);
                    until CreditCardMapping.Next = 0;
            end;

            MappingFieldCount := CreditCardMapping.Count;
            if (EMSetup."Use CC Mapping for dup. Cards") and (MappingFieldCount = 0) then
                Error(NoCreditCardMapping, CreditCardMapping.TableCaption, EMSetup.FieldCaption("Use CC Mapping for dup. Cards"));

            InboxTransaction.SetCurrentKey("Card No.", Status);
            InboxTransaction.SetRange("Card No.", UserCreditCard."Card No.");
            InboxTransaction.SetFilter(Status, '%1|%2', InboxTransaction.Status::Pending, InboxTransaction.Status::Error);
            InboxTransaction.SetRange("Continia User ID", '');
            if not EMSetup."Use CC Mapping for dup. Cards" then begin
                UserCreditCard.Reset;
                UserCreditCard.SetRange("Card No.", "Card No.");
                if UserCreditCard.Count = 1 then begin
                    InboxTransaction.ModifyAll(Status, InboxTransaction.Status::Pending);
                    InboxTransaction.ModifyAll("Error Text", '');
                    InboxTransaction.ModifyAll("User Paid Credit Card", UserCreditCard."User Paid Credit Card");
                    InboxTransaction.ModifyAll("Continia User ID", UserCreditCard."Continia User ID");
                end else begin
                    if Status <> Status::Accepted then begin
                        Status := Status::Pending;
                        "Error Text" := '';
                        "Continia User ID" := UserCreditCard."Continia User ID";
                        "User Paid Credit Card" := UserCreditCard."User Paid Credit Card";
                        Modify;
                    end;
                end;
            end else
                if InboxTransaction.FindSet then
                    repeat
                        ContiniaUserID := BankTransactionInboxCheck.GetMappingCreditCard(InboxTransaction, MappingFieldCount);
                        if ContiniaUserID <> '' then begin
                            UserCreditCard.Get(ContiniaUserID, InboxTransaction."Card No.");
                            InboxTransaction.Status := InboxTransaction.Status::Pending;
                            InboxTransaction."Error Text" := '';
                            InboxTransaction."Continia User ID" := ContiniaUserID;
                            InboxTransaction."User Paid Credit Card" := UserCreditCard."User Paid Credit Card";
                            InboxTransaction.Modify;
                        end;
                    until InboxTransaction.Next = 0;

            Commit;
            if not UserCreditCardBankConfigured then
                if PostingAccountAction = PostingAccountAction::SetupManually then begin
                    UserCreditCard.SetRange("Continia User ID", ContiniaUserSetup."Continia User ID");
                    PAGE.RunModal(0, UserCreditCard);
                end;

            CODEUNIT.Run(CODEUNIT::"CEM Online Synch. Mgt.");
        end;
    end;


    procedure UnMatchCard()
    var
        InboxTransaction: Record "CEM Bank Transaction Inbox";
        EmployeeCard: Record "CEM Continia User Credit Card";
        CreditCardUserMapping: Record "CEM Credit Card User Mapping";
    begin
        TestField("Continia User ID");
        TestField("Card No.");
        if Status = Status::Accepted then
            FieldError(Status, NotValidStatus);

        EmployeeCard.Get("Continia User ID", "Card No.");
        EmployeeCard.Delete(true);

        InboxTransaction.SetCurrentKey("Card No.", Status);
        InboxTransaction.SetRange("Card No.", "Card No.");
        InboxTransaction.SetRange("Continia User ID", "Continia User ID");
        InboxTransaction.SetFilter(Status, '%1|%2', InboxTransaction.Status::Pending, InboxTransaction.Status::Error);
        InboxTransaction.ModifyAll("Continia User ID", '');
        InboxTransaction.ModifyAll("User Paid Credit Card", false);

        CreditCardUserMapping.SetRange("Card No.", "Card No.");
        CreditCardUserMapping.SetRange("Continia User ID", "Continia User ID");
        CreditCardUserMapping.DeleteAll;
    end;


    procedure UploadFile(ReconciliationFile: Boolean)
    var
        Bank: Record "CEM Bank";
    begin
        if Bank.Count = 1 then
            Bank.FindFirst
        else
            if PAGE.RunModal(0, Bank) <> ACTION::LookupOK then
                exit;

        UploadFileFromBank(Bank, ReconciliationFile);
    end;

    local procedure UploadFileFromBank(Bank: Record "CEM Bank"; ReconciliationFile: Boolean)
    var
        TempFile: Record "CDC Temp File" temporary;
        BankTransOnlineMgt: Codeunit "CEM Bank Trans. Online Mgt.";
        EMOnlineMgt: Codeunit "CEM Online Synch. Mgt.";
    begin
        TempFile.BrowseFile(SelectBankTxt, '.csv', BankFileFilters);
        if TempFile.Data.HasValue then begin
            BankTransOnlineMgt.UploadBankFile(Bank, TempFile, ReconciliationFile);
            EMOnlineMgt.Run;
        end;
    end;

    local procedure IsDuplicate(): Boolean
    var
        BankTrans: Record "CEM Bank Transaction";
        BankTransInbox: Record "CEM Bank Transaction Inbox";
        EMSetup: Record "CEM Expense Management Setup";
    begin
        if "Transaction ID" <> '' then
            exit(false);

        EMSetup.Get;
        if EMSetup."Ignore BT Duplicate Check" then
            exit(false);

        BankTransInbox.SetCurrentKey("Card No.", Status, "Posting Date");
        BankTransInbox.SetFilter("Entry No.", '<>%1', "Entry No.");
        BankTransInbox.SetRange("Card No.", "Card No.");
        BankTransInbox.SetRange(Status, BankTransInbox.Status::Pending, BankTransInbox.Status::Error);
        BankTransInbox.SetRange("Posting Date", "Posting Date");
        BankTransInbox.SetRange("Document Time", "Document Time");
        BankTransInbox.SetRange("Currency Code", "Currency Code");
        BankTransInbox.SetRange(Amount, Amount);
        BankTransInbox.SetRange("Bank Statement Transaction", "Bank Statement Transaction");
        if not BankTransInbox.IsEmpty then
            exit(IsExcludedDuplicate);

        BankTrans.SetCurrentKey("Card No.");
        BankTrans.SetFilter("Entry No.", '<>%1', "Entry No.");
        BankTrans.SetRange("Card No.", "Card No.");
        BankTrans.SetRange("Posting Date", "Posting Date");
        BankTrans.SetRange("Document Time", "Document Time");
        BankTrans.SetRange("Currency Code", "Currency Code");
        BankTrans.SetRange(Amount, Amount);
        BankTrans.SetRange("Bank Statement Transaction", "Bank Statement Transaction");
        if not BankTrans.IsEmpty then
            exit(IsExcludedDuplicate);

        exit(false);
    end;

    local procedure IsExcludedDuplicate(): Boolean
    var
        DuplicateException: Record "CEM Duplicate Exception";
    begin
        DuplicateException.SetRange("Business Name", "Business Name");
        DuplicateException.SetFilter("Maximum Amount(LCY)", '<=%1', Abs("Bank-Currency Amount"));
        exit(DuplicateException.IsEmpty);
    end;


    procedure MarkNotDuplicate()
    var
        NotDuplicate: Record "CEM Duplicate Exception";
    begin
        NotDuplicate.MakeNotDuplicate(Rec);
    end;


    procedure IsDuplicateFromBank(TransactionID: Text[50]; IsStatement: Boolean): Boolean
    var
        BankTrans: Record "CEM Bank Transaction";
        BankTransInbox: Record "CEM Bank Transaction Inbox";
    begin
        if TransactionID = '' then
            exit(false);

        BankTransInbox.SetCurrentKey("Transaction ID");
        BankTransInbox.SetRange("Transaction ID", TransactionID);
        BankTransInbox.SetRange("Bank Statement Transaction", IsStatement);
        if not BankTransInbox.IsEmpty then
            exit(true);

        BankTrans.SetCurrentKey("Transaction ID");
        BankTrans.SetRange("Transaction ID", TransactionID);
        BankTrans.SetRange("Bank Statement Transaction", IsStatement);
        if not BankTrans.IsEmpty then
            exit(true);
    end;


    procedure GetNoOfEntriesWithError(): Integer
    var
        BankTransInbox: Record "CEM Bank Transaction Inbox";
    begin
        BankTransInbox.SetCurrentKey(Status);
        BankTransInbox.SetRange(Status, BankTransInbox.Status::Error);
        exit(BankTransInbox.Count);
    end;


    procedure PostingDateAllowedCheck()
    begin
        if not ValidPostingDate("Posting Date") then
            Error(PostingDateNotAllowedErr, "Posting Date");
    end;

    local procedure ValidPostingDate(PostingDate: Date): Boolean
    var
        GenJnlCheckLine: Codeunit "Gen. Jnl.-Check Line";
    begin
        exit(not GenJnlCheckLine.DateNotAllowed(PostingDate));
    end;
}


//
//  Copyright (c) 2020 Open Whisper Systems. All rights reserved.
//

import Foundation

@objc
class PhoneNumberDiscoverabilitySettingsTableViewController: OWSTableViewController {
    static var tsAccountManager: TSAccountManager {
        return .sharedInstance()
    }

    var tsAccountManager: TSAccountManager {
        return .sharedInstance()
    }

    var databaseStorage: SDSDatabaseStorage {
        return .shared
    }

    @objc
    class var nameForCurrentDiscoverability: String {
        return nameForDiscoverability(tsAccountManager.isDiscoverableByPhoneNumber())
    }

    class func nameForDiscoverability(_ isDiscoverable: Bool) -> String {
        if isDiscoverable {
            return NSLocalizedString("PHONE_NUMBER_DISCOVERABILITY_EVERYBODY",
                                     comment: "A user friendly name for the 'everybody' phone number discoverability mode.")
        } else {
            return NSLocalizedString("PHONE_NUMBER_DISCOVERABILITY_NOBODY",
                                     comment: "A user friendly name for the 'nobody' phone number discoverability mode.")
        }
    }

    @objc
    class var descriptionForCurrentDiscoverability: String {
        if tsAccountManager.isDiscoverableByPhoneNumber() {
            return NSLocalizedString("PHONE_NUMBER_DISCOVERABILITY_EVERYBODY_DESCRIPTION",
                                     comment: "A user friendly description of the 'everybody' phone number discoverability mode.")
        } else {
            return NSLocalizedString("PHONE_NUMBER_DISCOVERABILITY_NOBODY_DESCRIPTION",
                                     comment: "A user friendly description of the 'nobody' phone number discoverability mode.")

        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        title = NSLocalizedString("SETTINGS_PHONE_NUMBER_DISCOVERABILITY_TITLE",
                                  comment: "The title for the phone number discoverability settings.")

        self.useThemeBackgroundColors = true

        updateTableContents()
    }

    func updateTableContents() {
        let contents = OWSTableContents()

        let section = OWSTableSection()
        section.customHeaderView = .spacer(withHeight: 32)
        section.footerTitle = Self.descriptionForCurrentDiscoverability

        section.add(discoverabilityItem(true))
        section.add(discoverabilityItem(false))

        contents.addSection(section)

        self.contents = contents
    }

    func discoverabilityItem(_ isDiscoverable: Bool) -> OWSTableItem {
        return OWSTableItem(
            text: Self.nameForDiscoverability(isDiscoverable),
            actionBlock: { [weak self] in
                self?.changeDiscoverability(isDiscoverable)
            },
            accessoryType: tsAccountManager.isDiscoverableByPhoneNumber() == isDiscoverable ? .checkmark : .none
        )
    }

    func changeDiscoverability(_ isDiscoverable: Bool) {
        databaseStorage.asyncWrite(block: { [weak self] transaction in
            self?.tsAccountManager.setIsDiscoverableByPhoneNumber(
                isDiscoverable,
                updateStorageService: true,
                transaction: transaction
            )
        }) { [weak self] in
            self?.updateTableContents()
        }
    }
}

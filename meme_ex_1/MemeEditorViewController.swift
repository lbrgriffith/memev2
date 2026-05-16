//
//  MemeEditorViewController.swift
//  meme_ex_1
//
//  Created by Ricardo Griffith on 19/01/2016.
//  Copyright © 2016 Developer Play. All rights reserved.
//

import UIKit
import PhotosUI

final class MemeEditorViewController: UIViewController {

    // MARK: Outlets

    @IBOutlet weak var imagePicked: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var textTop: UITextField!
    @IBOutlet weak var textBottom: UITextField!
    @IBOutlet weak var bottomToolBar: UIToolbar!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var shareButton: UIBarButtonItem!

    // MARK: State

    private let defaultTopText = "TOP"
    private let defaultBottomText = "BOTTOM"

    var isEdit = false
    var memeToEdit: Meme?
    var removalIndex = 0

    private var keyboardObserversActive = false

    // MARK: Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        imagePicked.contentMode = .scaleAspectFit
        style(textTop, with: defaultTopText)
        style(textBottom, with: defaultBottomText)

        if isEdit, let meme = memeToEdit {
            textTop.text = meme.topString
            textBottom.text = meme.bottomString
            imagePicked.image = meme.originalImage
            shareButton.isEnabled = true
        } else {
            shareButton.isEnabled = false
        }
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        cameraButton.isEnabled = UIImagePickerController.isSourceTypeAvailable(.camera)
    }

    // MARK: Actions

    @IBAction func cancelMeme(_ sender: UIBarButtonItem) {
        textTop.text = defaultTopText
        textBottom.text = defaultBottomText
        imagePicked.image = nil
        dismiss(animated: true)
    }

    @IBAction func share(_ sender: Any) {
        let memedImage = generateMemedImage()
        let activityVC = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityVC.completionWithItemsHandler = { [weak self] _, completed, _, _ in
            guard let self, completed else { return }
            self.save(memedImage: memedImage)
        }
        present(activityVC, animated: true)
    }

    @IBAction func pickImage(_ sender: Any) {
        presentPhotoLibrary()
    }

    @IBAction func pickAnImageFromAlbum(_ sender: Any) {
        presentCamera()
    }

    // MARK: Picking

    private func presentPhotoLibrary() {
        var config = PHPickerConfiguration(photoLibrary: .shared())
        config.filter = .images
        config.selectionLimit = 1
        config.preferredAssetRepresentationMode = .current
        let picker = PHPickerViewController(configuration: config)
        picker.delegate = self
        present(picker, animated: true)
    }

    private func presentCamera() {
        guard UIImagePickerController.isSourceTypeAvailable(.camera) else { return }
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .camera
        present(picker, animated: true)
    }

    // MARK: Save

    private func save(memedImage: UIImage) {
        let unsaved = Meme(topString: textTop.text ?? "",
                           bottomString: textBottom.text ?? "",
                           originalImage: imagePicked.image ?? memedImage,
                           memeImage: memedImage)
        if isEdit {
            MemeStore.shared.replace(at: removalIndex, with: unsaved)
            dismiss(animated: true) { [weak self] in
                self?.presentingViewController?.dismiss(animated: false)
            }
        } else {
            MemeStore.shared.append(unsaved)
            dismiss(animated: true)
        }
    }

    // MARK: Memed image generation

    private func generateMemedImage() -> UIImage {
        topToolBar.isHidden = true
        bottomToolBar.isHidden = true
        defer {
            topToolBar.isHidden = false
            bottomToolBar.isHidden = false
        }

        let renderer = UIGraphicsImageRenderer(bounds: view.bounds)
        return renderer.image { _ in
            view.drawHierarchy(in: view.bounds, afterScreenUpdates: true)
        }
    }

    // MARK: Keyboard

    private func subscribeKeyboard() {
        guard !keyboardObserversActive else { return }
        keyboardObserversActive = true
        let center = NotificationCenter.default
        center.addObserver(self, selector: #selector(keyboardWillShow(_:)),
                           name: UIResponder.keyboardWillShowNotification, object: nil)
        center.addObserver(self, selector: #selector(keyboardWillHide(_:)),
                           name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func unsubscribeKeyboard() {
        guard keyboardObserversActive else { return }
        keyboardObserversActive = false
        let center = NotificationCenter.default
        center.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        center.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }

    private func keyboardHeight(from note: Notification) -> CGFloat {
        let frame = note.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue
        return frame?.cgRectValue.height ?? 0
    }

    @objc private func keyboardWillShow(_ note: Notification) {
        view.frame.origin.y = -keyboardHeight(from: note)
    }

    @objc private func keyboardWillHide(_ note: Notification) {
        view.frame.origin.y = 0
    }

    // MARK: Text styling

    private func style(_ field: UITextField, with placeholder: String) {
        let attributes: [NSAttributedString.Key: Any] = [
            .strokeColor: UIColor.black,
            .foregroundColor: UIColor.white,
            .font: UIFont(name: "HelveticaNeue-CondensedBlack", size: 40) ?? .systemFont(ofSize: 40, weight: .heavy),
            .strokeWidth: -3.0
        ]
        field.defaultTextAttributes = attributes
        field.textAlignment = .center
        field.delegate = self
        field.text = placeholder
    }
}

// MARK: - UITextFieldDelegate

extension MemeEditorViewController: UITextFieldDelegate {

    func textFieldDidBeginEditing(_ textField: UITextField) {
        if textField === textBottom {
            subscribeKeyboard()
        }
        if textField.text == defaultTopText || textField.text == defaultBottomText {
            textField.text = ""
        }
    }

    func textFieldDidEndEditing(_ textField: UITextField) {
        if textField === textBottom {
            unsubscribeKeyboard()
        }
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
}

// MARK: - PHPickerViewControllerDelegate

extension MemeEditorViewController: PHPickerViewControllerDelegate {

    func picker(_ picker: PHPickerViewController, didFinishPicking results: [PHPickerResult]) {
        picker.dismiss(animated: true)
        guard let provider = results.first?.itemProvider,
              provider.canLoadObject(ofClass: UIImage.self) else { return }

        provider.loadObject(ofClass: UIImage.self) { [weak self] object, _ in
            guard let image = object as? UIImage else { return }
            Task { @MainActor [weak self] in
                self?.imagePicked.image = image
                self?.shareButton.isEnabled = true
            }
        }
    }
}

// MARK: - UIImagePickerControllerDelegate (camera only)

extension MemeEditorViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController,
                               didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        if let image = info[.originalImage] as? UIImage {
            imagePicked.image = image
            shareButton.isEnabled = true
        }
        picker.dismiss(animated: true)
    }

    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true)
    }
}

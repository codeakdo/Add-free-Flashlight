import UIKit
import AVFoundation

//This project created by CodeAkdo

class ViewController: UIViewController {

    var player: AVAudioPlayer?

    var isTorchOn = false

    override func viewDidLoad() {
        super.viewDidLoad()
        updateUI()
    }
    
    let red = UIColor(hex: "#FF746C")
    let green = UIColor(hex: "#50C878")

    
    
    @IBAction func flashlightButtonTapped(_ sender: UIButton) {
        playSound(soundName: "click-sound")
        isTorchOn.toggle()
        toggleTorch(on: isTorchOn)
        updateUI()
        
    }

    func toggleTorch(on: Bool) {
        guard let device = AVCaptureDevice.default(for: .video),
              device.hasTorch else { return }

        do {
            try device.lockForConfiguration()

            if on {
                try device.setTorchModeOn(level: 1.0)
            } else {
                device.torchMode = .off
            }

            device.unlockForConfiguration()
        } catch {
            print("Torch ayarlanamadı: \(error)")
        }
    }

    func updateUI() {
        view.backgroundColor = isTorchOn ? green : red
    }
    func playSound(soundName: String) {
            guard let path = Bundle.main.path(forResource: soundName , ofType:"mp3") else {
                return }
            let url = URL(fileURLWithPath: path)
                player = try! AVAudioPlayer(contentsOf: url)
                player?.play()
       }
}
extension UIColor {
    public convenience init?(hex: String) {
        var hexSanitized = hex.trimmingCharacters(in: .whitespacesAndNewlines).uppercased()

        if hexSanitized.hasPrefix("#") {
            hexSanitized.remove(at: hexSanitized.startIndex)
        }

        var rgb: UInt64 = 0
        Scanner(string: hexSanitized).scanHexInt64(&rgb)

        switch hexSanitized.count {
        case 6:
            self.init(
                red: CGFloat((rgb & 0xFF0000) >> 16) / 255,
                green: CGFloat((rgb & 0x00FF00) >> 8) / 255,
                blue: CGFloat(rgb & 0x0000FF) / 255,
                alpha: 1.0
            )
        case 8:
            self.init(
                red: CGFloat((rgb & 0xFF000000) >> 24) / 255,
                green: CGFloat((rgb & 0x00FF0000) >> 16) / 255,
                blue: CGFloat((rgb & 0x0000FF00) >> 8) / 255,
                alpha: CGFloat(rgb & 0x000000FF) / 255
            )
        default:
            return nil
        }
    }

}
